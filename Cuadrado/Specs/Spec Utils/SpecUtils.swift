import UIKit

func loadStoryboard<T: UIViewController>(name: String) -> T {
    let storyboard = UIStoryboard(name: name, bundle: nil)
    
    guard let viewController = storyboard.instantiateInitialViewController() as? T else {
        preconditionFailure("Cannot load view controller from storyboard!")
    }
    
    return viewController
}

func loadCustomTableViewCell<T: UITableViewCell>(name: String) -> T {
    let nib = UINib(nibName: name, bundle: nil)
    
    let cell = (nib.instantiate(withOwner: nil, options: nil).first as! T)
    
    return cell
}

func createData(dict: Any) -> Data {
    return try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
}
