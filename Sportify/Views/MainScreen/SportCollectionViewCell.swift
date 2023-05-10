import UIKit

class SportCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: SportCollectionViewCell.self)
    
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var sportImageView: UIImageView!
    
    func setUp(_ sport: Sports) {
        sportLabel.text = sport.title
        sportImageView.image = sport.image
    }
}
