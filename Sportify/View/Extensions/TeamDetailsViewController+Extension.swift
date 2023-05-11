import Foundation
import UIKit

extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamDetailsResult.first?.players.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamsCell", for: indexPath) as! TeamDetailsTableViewCell
        
        if let player = teamDetailsResult.first?.players[indexPath.row] {
            cell.playerNameLabel.text = player.player_name
            cell.shirtNumberLabel.text = player.player_number
            cell.positionLabel.text = player.player_type
            cell.playerAgeLabel.text = player.player_age
            
            if let url = player.player_image, let imageUrl = URL(string: url) {
                cell.playerImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "player_placeholder"))
            } else {
                cell.playerImageView.image = UIImage(named: "player_placeholder")
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}
