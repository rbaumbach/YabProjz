import UIKit

protocol WeatherDetailViewControllerDelegate: AnyObject {
    func didTapClose()
}

class WeatherDetailViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: WeatherDetailViewControllerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        if navigationController == nil {
            closeButton.isHidden = false
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        delegate?.didTapClose()
    }
}
