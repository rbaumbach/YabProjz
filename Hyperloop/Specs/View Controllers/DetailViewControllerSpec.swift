import Quick
import Nimble
@testable import Hyperloop

final class FakeDetailViewControllerDelegate: DetailViewControllerDelegate {
    var didCallClose = false
    
    func didClose() {
        didCallClose = true
    }
}

class DetailViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("DetailViewController") {
            var subject: DetailViewController!
            var image: UIImage!
            var fakeDelegate: FakeDetailViewControllerDelegate!
            
            beforeEach {
                image = UIImage(systemName: "trash")
                fakeDelegate = FakeDetailViewControllerDelegate()
                
                subject = ViewControllerBuilder().build(name: "DetailViewController")
                subject.image = image
                subject.delegate = fakeDelegate
                
                _ = subject.view
            }
            
            describe("when the view loads") {
                beforeEach {
                    _ = subject.view
                }
                
                it("has a detailImageView") {
                    expect(subject.detailImageView).toNot(beNil())
                    expect(subject.detailImageView.image).toNot(beNil())
                }
                
                it("has a closeButton") {
                    expect(subject.closeButton).toNot(beNil())
                }
                
                describe("when the close button is tapped") {
                    beforeEach {
                        subject.didTapCloseButton(UIButton())
                    }
                    
                    it("notifies it's delegate that the view did close") {
                        expect(fakeDelegate.didCallClose).to(beTruthy())
                    }
                }
                
                describe("<UIScrollViewDelegate>") {
                    describe("#viewForZooming(in:)") {
                        var scrolledImageView: UIImageView!
                        
                        beforeEach {
                            scrolledImageView = (subject.viewForZooming(in: UIScrollView()) as! UIImageView)
                        }
                        
                        it("always returns the detailImageView") {
                            expect(subject.detailImageView).to(equal(scrolledImageView))
                        }
                    }
                }
            }
        }
    }
}
