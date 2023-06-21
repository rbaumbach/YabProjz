import UIKit

final class ImgurImageTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet weak var imgurImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Static properties
    
    static let identifier = "ImgurImageTableViewCell"
}
