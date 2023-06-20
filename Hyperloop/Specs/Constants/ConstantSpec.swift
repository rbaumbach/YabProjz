import Quick
import Nimble
@testable import Hyperloop

class ConstantsSpec: QuickSpec {
    override class func spec() {
        describe("Constants") {
            it("has appropriate content") {
                expect(Constants.Imgur.ClientID).to(equal("ABCD"))
                expect(Constants.Imgur.BaseURL).to(equal("https://api.imgur.com"))
            }
        }
    }
}
