import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func didClose()
}

final class DetailViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var detailImageVIew: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Public properties
    
    weak var delegate: DetailViewControllerDelegate?
    
    var image: UIImage?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        delegate?.didClose()
    }
    
    // MARK: - Private methods
    
    func setup() {
        detailImageVIew.image = image
    }
}
