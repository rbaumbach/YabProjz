import UIKit

class EmployeeTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    // MARK - Static helpers
    
    static let reuseId = "EmployeeTableViewCell"
    static let nib = UINib(nibName: reuseId, bundle: nil)
}
