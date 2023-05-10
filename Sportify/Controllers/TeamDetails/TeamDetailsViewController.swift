import UIKit
import Reachability
import CoreData
import Kingfisher

class TeamDetailsViewController: UIViewController {
    
    @IBOutlet weak var teamDetailsTableView: UITableView!
    @IBOutlet weak var teamLogoLabel: UILabel!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    
    let teamDetailsNetworkService: TeamDetailsProtocol = TeamDetailsNetworkService()
    var coreDataManager: CoreDataManager!
    var reachability: Reachability?
    var manager: ReachabilityNetworkManager?
    
    var teamDetailsResult: [TeamDetailsResult] = []
    
    var teamID = 0
    var sportName = ""
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.frame = view.frame
        containerView.backgroundColor = .systemBackground
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        reachability = try? Reachability()
        manager = ReachabilityNetworkManager(reachability: reachability)
        
        if manager!.isReachableViaWiFi() {
            fetchData()
        }
        
        coreDataManager = CoreDataManager(context: context)
    }
    
    func fetchData() {
        teamDetailsNetworkService.getTeamDetails(forTeamID: teamID, forSport: sportName) { results, error in
            guard let results = results else {
                if let error = error {
                    print("Error fetching data:", error.localizedDescription)
                } else {
                    print("No results found.")
                }
                return
            }
            self.teamDetailsResult = results
            
            DispatchQueue.main.async {
                self.teamDetailsTableView.reloadData()
                guard let teamDetails = self.teamDetailsResult.first else { return }
                self.teamLogoLabel.text = teamDetails.team_name
                self.teamLogoImageView.kf.setImage(with: URL(string: teamDetails.team_logo!))
                
                self.activityIndicator.stopAnimating()
                self.containerView.isHidden = true
            }
        }
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        guard let teamDetails = teamDetailsResult.first else { return }
        coreDataManager.insertTeam(teamKey: teamDetails.team_key!, teamName: teamDetails.team_name!, teamLogo: (teamLogoImageView.image?.pngData())!)
        
        let alert = UIAlertController(title: "Success", message: "Team added to favorites!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}
