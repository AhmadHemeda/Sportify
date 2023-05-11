import UIKit
import Reachability
import CoreData
import Kingfisher

protocol TeamDetailsProtocol {
    
    func trenderTeamDetailsTableView(teamDetailsResult: [TeamDetailsResult])
    
}

class TeamDetailsViewController: UIViewController, TeamDetailsProtocol {
    
    @IBOutlet weak var teamDetailsTableView: UITableView!
    @IBOutlet weak var teamLogoLabel: UILabel!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    
    let teamDetailsNetworkService: TeamDetailsNetworkServiceProtocol = TeamDetailsNetworkService()
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
        
        createIndicator()
        
        reachability = try? Reachability()
        manager = ReachabilityNetworkManager(reachability: reachability)
        
        if manager!.isReachableViaWiFi() {
            fetchData()
        }
        
        coreDataManager = CoreDataManager(context: context)
    }
    
    
    func trenderTeamDetailsTableView(teamDetailsResult: [TeamDetailsResult]) {
        self.teamDetailsResult = teamDetailsResult
        
        DispatchQueue.main.async {
            self.teamDetailsTableView.reloadData()
            guard let teamDetails = self.teamDetailsResult.first else { return }
            self.teamLogoLabel.text = teamDetails.team_name
            self.teamLogoImageView.kf.setImage(with: URL(string: teamDetails.team_logo!))
            
            self.activityIndicator.stopAnimating()
            self.containerView.isHidden = true
        }
    }
    
    func createIndicator() {
        containerView.frame = view.frame
        containerView.backgroundColor = .systemBackground
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func fetchData() {
        let teamDetailsPresenter = TeamDetailsPresenter()
        teamDetailsPresenter.getTeamDetails(teamDetailsProtocol: self, teamID: teamID, sportName: sportName)
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        guard let teamDetails = teamDetailsResult.first else { return }
        
        if coreDataManager.teamExists(teamKey: teamDetails.team_key!) {
            let alert = UIAlertController(title: "Remove Team", message: "Are you sure you want to remove this team from favorites?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                self.coreDataManager.deleteTeam(teamName: teamDetails.team_name!)
                
                let successAlert = UIAlertController(title: "Success", message: "Team removed from favorites!", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(successAlert, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            coreDataManager.insertTeam(teamKey: teamDetails.team_key!, teamName: teamDetails.team_name!, teamLogo: (teamLogoImageView.image?.pngData())!)
            
            let alert = UIAlertController(title: "Success", message: "Team added to favorites!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}
