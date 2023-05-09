import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didTapClose()
}

final class SettingsViewController: UIViewController {
    // MARK: - Public properties
    
    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: - IBActions
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        delegate?.didTapClose()
    }
}
