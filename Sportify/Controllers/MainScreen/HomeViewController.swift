import UIKit
import Reachability

class HomeViewController: UIViewController {
    
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sportsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
}
