import UIKit

final class TemperatureView: UIView {
    // MARK: - IBOutlet
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    
    // MARK: - Init methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TemperatureView",
                                 owner: self)
        
        addSubview(contentView)
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
