import UIKit
import Reachability

extension LeaguesTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func getPlaceholderImage() -> UIImage? {
        let imageName = defaultImages[sport.lowercased()] ?? "default_image"
        return UIImage(named: imageName)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaguesCell", for: indexPath) as! LeaguesTableViewCell
        
        let league: ResultFootball
        
        if leaguesSearchBar.text == "" {
            league = leagues[indexPath.row]
        } else {
            league = searchResults[indexPath.row]
        }

        cell.leagueNameLabel.text = league.league_name
        
        if let logoUrl = league.league_logo, let url = URL(string: logoUrl) {
            cell.leagueImageView.kf.setImage(with: url, placeholder: getPlaceholderImage())
        } else {
            cell.leagueImageView.image = getPlaceholderImage()
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reachability = try? Reachability()
        manager = ReachabilityNetworkManager(reachability: reachability)
        
        if manager!.isReachableViaWiFi() {
            let viewController = storyboard?.instantiateViewController(identifier: "LeagueDetailsViewController") as! LeagueDetailsViewController
            
            viewController.leagueID = searchResults[indexPath.row].league_key!
            viewController.sport = self.sport
            
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
        
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension LeaguesTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = leagues
        } else {
            searchResults = leagues.filter { $0.league_name?.lowercased().contains(searchText.lowercased()) ?? false }
        }

        leaguesTableView.reloadData()
    }
    
}
