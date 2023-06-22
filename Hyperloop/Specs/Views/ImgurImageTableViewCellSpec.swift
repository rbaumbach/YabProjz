import Quick
import Nimble
@testable import Hyperloop

class ImgurImageTableViewCellSpec: QuickSpec {
    override class func spec() {
        describe("ImgurImageTableViewCell") {
            var subject: ImgurImageTableViewCell!
            
            beforeEach {
                let nib = UINib(nibName: "ImgurImageTableViewCell", bundle: nil)
                
                subject = nib.instantiate(withOwner: nil).first as? ImgurImageTableViewCell
            }
            
            it("has the proper identifier") {
                expect(ImgurImageTableViewCell.identifier).to(equal("ImgurImageTableViewCell"))
            }
            
            it("has an image view") {
                expect(subject.imgurImageView).toNot(beNil())
            }
            
            it("has a description") {
                expect(subject.descriptionLabel.text).to(equal("Description"))
            }
        }
    }
}
            
