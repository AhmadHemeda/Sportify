import UIKit
import Reachability

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sportsCollectionView.dequeueReusableCell(withReuseIdentifier: SportCollectionViewCell.identifier, for: indexPath) as! SportCollectionViewCell
        
        cell.setUp(sports[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reachability = try! Reachability()
        let manager = ReachabilityNetworkManager(reachability: reachability)

        if manager.isReachableViaWiFi() {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LeaguesTableViewController") as! LeaguesTableViewController
            let sportName = sports[indexPath.row].title
            viewController.sport = sportName
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }

        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (sportsCollectionView.frame.width - 10) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
