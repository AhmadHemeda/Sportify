import UIKit
import Reachability
import Kingfisher

class LeaguesTableViewController: UIViewController {
    
    @IBOutlet weak var leaguesTableView: UITableView!
    @IBOutlet weak var leaguesSearchBar: UISearchBar!
    
    var reachability: Reachability?
    var manager: ReachabilityNetworkManager?
    
    let leaguesNetworkService: LeaguesNetworkServiceProtocol = LeaguesNetworkService()
    
    var sport = ""
    var leagues: [ResultFootball] = []
    var searchResults : [ResultFootball] = []

    let defaultImages: [String: String] = [
        "football": "placeholder_football",
        "basketball": "placeholder_basketball",
        "tennis": "placeholder_tennis",
        "cricket": "placeholder_cricket"
    ]
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createIndicator()
        
        reachability = try? Reachability()
        manager = ReachabilityNetworkManager(reachability: reachability)
        
        if manager!.isReachableViaWiFi() {
            activityIndicator.startAnimating()
            fetchData() { [weak self] in
                self?.searchResults = self?.leagues ?? []
                self?.leaguesTableView.reloadData()
            }
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
        
        view.addSubview(containerView)
    }
    
    func fetchData(completion: @escaping () -> Void) {
        leaguesNetworkService.getAllLeagues(forSport: sport) { [weak self] results, error in
            guard let self = self, let results = results else {
                if let error = error {
                    print("Error fetching data:", error.localizedDescription)
                } else {
                    print("No results found.")
                }
                return
            }
            self.leagues = results

            DispatchQueue.main.async {
                self.leaguesTableView.reloadData()

                self.activityIndicator.stopAnimating()
                self.containerView.isHidden = true
                completion()
            }
        }
    }
    
    deinit {
        reachability!.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}
