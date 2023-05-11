import UIKit
import Lottie
import Reachability
import CoreData

class FavoriteTeamsViewController: UIViewController {
    
    @IBOutlet weak var favoriteSplashView: UIView!
    @IBOutlet weak var favoriteTeamsTableView: UITableView!
    
    var reachability: Reachability?
    var manager: ReachabilityNetworkManager?
    
    var context: NSManagedObjectContext!
    var coreDataManager: CoreDataManager!
    var favoriteTeams: [FavoriteTeam] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Favorite teams"
        
        showLottie()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        coreDataManager = CoreDataManager(context: context)
        favoriteTeams = coreDataManager.getAllTeams()
        
        favoriteTeamsTableView.reloadData()
    }
    
    func showLottie() {
        let animationView = LottieAnimationView(name: "favorite_teams")
        
        favoriteSplashView.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.leadingAnchor.constraint(equalTo: favoriteSplashView.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: favoriteSplashView.trailingAnchor).isActive = true
        animationView.topAnchor.constraint(equalTo: favoriteSplashView.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: favoriteSplashView.bottomAnchor).isActive = true
        
        animationView.contentMode = .scaleAspectFit
        
        animationView.loopMode = .loop
        
        animationView.play()
    }

}
