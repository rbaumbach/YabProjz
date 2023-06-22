import UIKit
@testable import Hyperloop

final class FakeViewControllerBuilder: ViewControllerBuilderProtocol {
    // MARK: - Captured properties
    
    var capturedName: String?
    
    // MARK: - Stubbed properties
    
    var stubbedViewController = UIViewController()
    
    func build<T: UIViewController>(name: String) -> T {
        capturedName = name
        
        return stubbedViewController as! T
    }
}
