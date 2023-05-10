import UIKit

class LeaguesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leagueView: UIView!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leagueImageView.layer.cornerRadius = leagueImageView.bounds.size.width/2
        leagueImageView.clipsToBounds = true
    }
    
}
