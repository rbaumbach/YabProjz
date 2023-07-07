import UIKit
import SDWebImage

protocol DetalleViewControllerDelegate: AnyObject {
    func didClose()
}

final class DetalleViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Public properties
    
    weak var delegate: DetalleViewControllerDelegate?
        
    var imgurImageIndex = 0
    var imgurImages: [ImgurImage]!
    
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
    
    @IBAction func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        guard imgurImageIndex < imgurImages.count - 1 else { return }
        
        navigateImageForward()
    }
    
    @IBAction func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
        guard imgurImageIndex > 0 else { return }
        
        navigateImageBackward()
    }
    
    // MARK: - Private methods
    
    func setup() {
        detailImageView.sd_setImage(with: imgurImages[imgurImageIndex].url,
                                    placeholderImage: UIImage(systemName: Constants.App.imagePlaceholderName))
    }
    
    private func navigateImageForward() {
        navigateImage(shouldGoFoward: true)
    }
    
    private func navigateImageBackward() {
        navigateImage(shouldGoFoward: false)
    }
    
    private func navigateImage(shouldGoFoward: Bool) {
        if shouldGoFoward {
            imgurImageIndex += 1

        } else {
            imgurImageIndex -= 1
        }
        
        let imageURL = imgurImages[imgurImageIndex].url
        
        detailImageView.sd_setImage(with: imageURL,
                                    placeholderImage: UIImage(systemName: Constants.App.imagePlaceholderName))
    }
}
