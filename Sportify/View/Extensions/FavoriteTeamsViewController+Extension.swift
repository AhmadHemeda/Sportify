import UIKit
import Reachability

extension FavoriteTeamsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTeamsTableViewCell
        
        let favoriteTeam = favoriteTeams[indexPath.row]
        
        cell.favoriteTeamLabel.text = favoriteTeam.teamName
        cell.favoriteTeamImageView.image = UIImage(data: favoriteTeam.teamLogo!)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let teamToDelete = favoriteTeams[indexPath.row]
            let alert = UIAlertController(title: "Delete Team", message: "Are you sure you want to delete \(teamToDelete.teamName!)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                self.coreDataManager.deleteTeam(teamName: teamToDelete.teamName!)
                self.favoriteTeams.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reachability = try? Reachability()
        manager = ReachabilityNetworkManager(reachability: reachability)
        
        if manager!.isReachableViaWiFi() {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController {
                viewController.sportName = "Football"
                viewController.teamID = favoriteTeams[indexPath.row].teamKey!
                self.navigationController?.pushViewController(viewController, animated: true)
                return
            }
        }
        
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
