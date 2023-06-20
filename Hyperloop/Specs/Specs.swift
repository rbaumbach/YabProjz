import Quick
import Nimble
@testable import Hyperloop

struct ViewControllerBuilder {
    func build<T: UIViewController>(name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        return storyboard.instantiateInitialViewController()!
    }
}

class MainViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("MainViewController") {
            var subject: MainViewController!
            
            beforeEach {
                subject = ViewControllerBuilder().build(name: "MainViewController")
                
                _ = subject.view
            }
            
            it("exists") {
                expect(subject).toNot(beNil())
            }
        }
    }
}
