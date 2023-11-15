import Quick
import Nimble
@testable import Unsplasher

// Note: These tests are "integration'y".  One test is here just for coverage.

final class ViewControllerBuilderTests: QuickSpec {
    override class func spec() {
        describe("ViewControllerBuilder") {
            it("can build a view controller from a storyboard") {
                let viewController: UIViewController = ViewControllerBuilder().build(name: "Launch")
                
                expect(viewController).toNot(beNil())
            }
        }
    }
}
