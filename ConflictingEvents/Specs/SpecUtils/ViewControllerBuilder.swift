import UIKit

final class ViewControllerBuilder {
    func build<T: UIViewController>(name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        return storyboard.instantiateInitialViewController() as! T
    }
}
