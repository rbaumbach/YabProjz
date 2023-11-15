import UIKit

protocol ViewControllerBuilderProtocol {
    func build<T: UIViewController>(name: String) -> T
}

final class ViewControllerBuilder: ViewControllerBuilderProtocol {
    func build<T: UIViewController>(name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        return storyboard.instantiateInitialViewController() as! T
    }
}
