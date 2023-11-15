import Quick
import Nimble
@testable import Unsplasher

final class ConstantsTests: QuickSpec {
    override class func spec() {
        describe("Constants") {
            describe("Unsplash") {
                it("has appropriate keys") {
                    expect(Constants.Unsplash.AccessKey).to(equal("<Enter-your-access-key-here>"))
                    expect(Constants.Unsplash.SecretKey).to(equal("<Enter-your-secret-key-here>"))
                }
            }
        }
    }
}
