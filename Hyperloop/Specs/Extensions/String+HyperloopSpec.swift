import Quick
import Nimble
@testable import Hyperloop

class String_HyperloopSpec: QuickSpec {
    override class func spec() {
        describe("String+Hyperloop") {
            it("has static empty property") {
                expect(String.empty).to(equal(""))
            }
        }
    }
}
