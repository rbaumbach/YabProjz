import UIKit

class ArticleTableViewCell: UITableViewCell {
    // MARK - IBOutlets
    
    @IBOutlet weak var articleContentView: UIView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleImageViewLayoutHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        articleContentView.layer.borderWidth = 1
        articleContentView.layer.borderColor = UIColor.black.cgColor
        
        articleImageView.layer.borderWidth = 1
        articleImageView.layer.borderColor = UIColor.black.cgColor
    }
}
