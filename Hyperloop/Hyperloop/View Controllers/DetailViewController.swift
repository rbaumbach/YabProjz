import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func didClose()
}

final class DetailViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Public properties
    
    weak var delegate: DetailViewControllerDelegate?
    
    var image: UIImage?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - <UIScrollViewDelegate>
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detailImageView
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        delegate?.didClose()
    }
    
    // MARK: - Private methods
    
    func setup() {
        detailImageView.image = image
    }
}
