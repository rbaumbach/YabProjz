import Quick
import Nimble
@testable import Hyperloop

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
