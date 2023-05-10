import UIKit
import Reachability

class LeagueDetailsViewController: UIViewController {
    
    @IBOutlet weak var fixtureCollectionView: UICollectionView!
    @IBOutlet weak var livescoreCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    var reachability: Reachability?
    var manager: ReachabilityNetworkManager?
    
    var leagueID: Int = 0
    var sport: String = ""
    var fixtures: [Result] = []
    var livescores: [LivescoreResult] = []
    var teams: [Teams] = []
    let networkService = LeagueDetailsNetworkService()
    let dateFormatter = DateFormatter()
    
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
            activityIndicator.startAnimating()
            
            fetchData()
        }
        
        teamsCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func fetchData() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let nextWeek = Calendar.current.date(byAdding: .day, value: 15, to: today)!
        
        networkService.getData(forLeagueID: leagueID, forSport: sport, fromDate: today, toDate: nextWeek) { (results, error) in
            if let error = error {
                print("Error fetching data:", error.localizedDescription)
                return
            }
            guard let results = results else {
                print("No results found.")
                return
            }
            self.fixtures = results
            
            for fixture in self.fixtures {
                switch self.sport {
                case "Football":
                    if let homeTeamKey = fixture.home_team_key, let homeTeamLogo = fixture.home_team_logo {
                        self.updateTeamsArray(teamKey: homeTeamKey, teamLogo: homeTeamLogo)
                    }
                    if let awayTeamKey = fixture.away_team_key, let awayTeamLogo = fixture.away_team_logo {
                        self.updateTeamsArray(teamKey: awayTeamKey, teamLogo: awayTeamLogo)
                    }
                case "Tennis":
                    if let homeTeamKey = fixture.first_player_key, let homeTeamLogo = fixture.event_first_player_logo {
                        self.updateTeamsArray(teamKey: homeTeamKey, teamLogo: homeTeamLogo)
                    }
                    if let awayTeamKey = fixture.second_player_key, let awayTeamLogo = fixture.event_second_player_logo {
                        self.updateTeamsArray(teamKey: awayTeamKey, teamLogo: awayTeamLogo)
                    }
                default:
                    if let homeTeamKey = fixture.home_team_key, let homeTeamLogo = fixture.event_home_team_logo {
                        self.updateTeamsArray(teamKey: homeTeamKey, teamLogo: homeTeamLogo)
                    }
                    if let awayTeamKey = fixture.away_team_key, let awayTeamLogo = fixture.event_away_team_logo {
                        self.updateTeamsArray(teamKey: awayTeamKey, teamLogo: awayTeamLogo)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.fixtureCollectionView.reloadData()
                self.teamsCollectionView.reloadData()
                
                self.activityIndicator.stopAnimating()
                self.containerView.isHidden = true
            }
        }
        
        networkService.getLivescore(forSport: sport) { (results, error) in
            if let error = error {
                print("Error fetching data:", error.localizedDescription)
                return
            }
            guard let results = results else {
                print("No results found.")
                return
            }
            self.livescores = results
            
            DispatchQueue.main.async {
                self.livescoreCollectionView.reloadData()
            }
        }
    }
    
    private func updateTeamsArray(teamKey: Int, teamLogo: String) {
        if !self.teams.contains(where: { $0.teamKey == teamKey }) {
            let team = Teams(teamKey: teamKey, teamLogo: teamLogo)
            self.teams.append(team)
        }
    }
    
    deinit {
        reachability!.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}
