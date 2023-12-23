import UIKit

final class EventTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    static let name = String(describing: EventTableViewCell.self)
    
    // MARK: - Public methods
    
    func update(title: String, startDate: String, endDate: String, hasConflict: Bool = false) {
        titleLabel.text = title
        startDateLabel.text = startDate
        endDateLabel.text = endDate
        
        if hasConflict {
            titleLabel.text?.append(" - CONFLICT!")
            titleLabel.textColor = .red
        } else {
            titleLabel.textColor = .black
        }
    }
}
