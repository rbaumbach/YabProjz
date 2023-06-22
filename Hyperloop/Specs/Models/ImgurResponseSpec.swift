import Quick
import Nimble
@testable import Hyperloop

class ImgurResponseSpec: QuickSpec {
    override class func spec() {
        describe("ImgurResponse") {
            var subject: ImgurResponse!
            
            beforeEach {
                let imgurItem = ImgurItem(id: "1",
                                          title: "Yay photos!",
                                          images: [])
                
                subject = ImgurResponse(data: [imgurItem])
            }
            
            it("has data (array of ImgurItems)") {
                expect(subject.data.first?.id).to(equal("1"))
                expect(subject.data.first?.title).to(equal("Yay photos!"))
                expect(subject.data.first?.images).to(beEmpty())
            }
        }
    }
}
