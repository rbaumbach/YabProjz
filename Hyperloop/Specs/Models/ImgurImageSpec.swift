import Quick
import Nimble
@testable import Hyperloop

class ImgurImageSpec: QuickSpec {
    override class func spec() {
        describe("ImgurImage") {
            var subject: ImgurImage!
            
            beforeEach {
                subject = ImgurImage(id: "0",
                                     description: "Taco Bell Dog",
                                     mediaType: .image,
                                     url: URL(string: "https://en.wikipedia.org/wiki/Taco_Bell_chihuahua"))
            }
            
            it("has an id") {
                expect(subject.id).to(equal("0"))
            }

            it("has a description") {
                expect(subject.description).to(equal("Taco Bell Dog"))
            }

            it("has a mediaType") {
                expect(subject.mediaType).to(equal(.image))
            }

            it("has URL") {
                expect(subject.url).to(equal(URL(string: "https://en.wikipedia.org/wiki/Taco_Bell_chihuahua")))
            }
        }
    }
}
