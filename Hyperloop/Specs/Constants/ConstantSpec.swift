import Quick
import Nimble
@testable import Hyperloop

class ConstantsSpec: QuickSpec {
    override class func spec() {
        describe("Constants") {
            describe("Imgur") {
                it("has appropriate content") {
                    expect(Constants.Imgur.ClientIDKey).to(equal("Authorization"))
                    expect(Constants.Imgur.ClientIDValue).to(equal("Client-ID <Enter your ClientID here>"))
                    expect(Constants.Imgur.BaseURL).to(equal("https://api.imgur.com"))
                }
            }
            
            describe("App") {
                it("has appropriate content") {
                    expect(Constants.App.mainTitle).to(equal("Imgur Search"))
                    expect(Constants.App.imagePlaceholderName).to(equal("photo"))
                    expect(Constants.App.defaultImgurImageDescription).to(equal("N/A"))
                    expect(Constants.App.defaultSearchTerm).to(equal("Chihuahua"))
                    
                    
                    expect(Constants.App.mainTableViewCellHeight).to(beCloseTo(132.0))
                    expect(Constants.App.defaultDebouncerTime).to(beCloseTo(0.3))
                }
            }
        }
    }
}
