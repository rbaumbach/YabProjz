import Quick
import Nimble
@testable import Hyperloop

class ViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("ViewController") {
            var subject: ViewController!
            
            beforeEach {
                subject = ViewController()
                
                _ = subject.view
            }
            
            it("exists") {
                expect(subject).toNot(beNil())
            }
        }
    }
}
