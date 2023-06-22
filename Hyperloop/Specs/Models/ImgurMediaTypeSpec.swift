import Quick
import Nimble
@testable import Hyperloop

class ImgurMediaTypeSpec: QuickSpec {
    override class func spec() {
        describe("ImgurMediaType") {
            it("has proper cases with correct raw values") {
                expect(ImgurMediaType.image.rawValue).to(equal("image/jpeg"))
                expect(ImgurMediaType.video.rawValue).to(equal("video/mp4"))
                expect(ImgurMediaType.unknown.rawValue).to(equal("unknown"))
            }
        }
    }
}
