import UIKit
import Reachability

protocol LeagueDetailsProtocol {
    func renderFixtureCollectionView(result: [Result])
    func renderLivescoreCollectionView(livescores: [LivescoreResult])
}

class LeagueDetailsViewController: UIViewController, LeagueDetailsProtocol {
    
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
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var containerView = UIView()
    
    func renderFixtureCollectionView(result: [Result]) {
        self.fixtures = result.reversed()
        
        fillTeamsArray(fixtures: result)
        
        DispatchQueue.main.async {
            self.fixtureCollectionView.reloadData()
            self.teamsCollectionView.reloadData()
            
            self.activityIndicator.stopAnimating()
            self.containerView.isHidden = true
        }
    }
    
    func renderLivescoreCollectionView(livescores: [LivescoreResult]) {
        self.livescores = livescores
        
        DispatchQueue.main.async {
            self.livescoreCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createIndicator()
        
        reachability = try? Reachability()
        manager = ReachabilityNetworkManager(reachability: reachability)
        
        if manager!.isReachableViaWiFi() {
            activityIndicator.startAnimating()
            
            fetchData()
        }
    }
    
    func fetchData() {
        
        let fixturePresenter = FixturePresenter()
        fixturePresenter.getFixtures(leagueDetailsProtocol: self, leagueID: leagueID, sport: sport)
        
        
        let livescorePresenter = LivescorePresenter()
        livescorePresenter.getLivescore(leagueDetailsProtocol: self, sport: sport)
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
    
    private func fillTeamsArray(fixtures: [Result]) {
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
