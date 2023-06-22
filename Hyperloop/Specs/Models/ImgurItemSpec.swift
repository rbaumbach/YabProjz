import Quick
import Nimble
@testable import Hyperloop

class ImgurItemSpec: QuickSpec {
    override class func spec() {
        describe("ImgurItem") {
            var subject: ImgurItem!
            
            beforeEach {
                subject = ImgurItem(id: "-1", title: "Negative One", images: [])
            }
            
            it("has an id") {
                expect(subject.id).to(equal("-1"))
            }
            
            it("has a title") {
                expect(subject.title).to(equal("Negative One"))
            }
            
            it("has images") {
                expect(subject.images).to(beEmpty())
            }
        }
    }
}
