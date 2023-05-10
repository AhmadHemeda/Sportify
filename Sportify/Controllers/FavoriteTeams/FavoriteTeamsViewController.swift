import UIKit
import Reachability
import CoreData

class FavoriteTeamsViewController: UIViewController {
    
    @IBOutlet weak var favoriteTeamsTableView: UITableView!
    
    var reachability: Reachability?
    var manager: ReachabilityNetworkManager?
    
    var context: NSManagedObjectContext!
    var coreDataManager: CoreDataManager!
    var favoriteTeams: [FavoriteTeam] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        coreDataManager = CoreDataManager(context: context)
        favoriteTeams = coreDataManager.getAllTeams()
        
        favoriteTeamsTableView.reloadData()
    }
    
    @objc func reachabilityChanged(_ notification: Notification) {
        let reachability = notification.object as! Reachability
        if reachability.connection == .unavailable {
            print("Network Unavailable")
        } else {
            print("Network Available")
        }
    }

}
