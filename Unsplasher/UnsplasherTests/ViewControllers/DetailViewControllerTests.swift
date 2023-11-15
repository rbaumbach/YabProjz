import Quick
import Nimble
@testable import Unsplasher

final class FakeDetailViewControllerDelegate: DetailViewControllerDelegate {
    var didCallClose = false
    
    func didClose() {
        didCallClose = true
    }
}

final class DetailViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("DetailViewController") {
            var subject: DetailViewController!
            var fakeDelegate: FakeDetailViewControllerDelegate!
            
            beforeEach {
                fakeDelegate = FakeDetailViewControllerDelegate()
                
                subject = ViewControllerBuilder().build(name: "DetailViewController")
                subject.delegate = fakeDelegate
            }
            
            it("has a tempImage") {
                expect(subject.tempImage).to(equal(UIImage(systemName: "photo")))
            }

            describe("when the view loads") {
                // Note: If extensive error handling was ever warranted, the full SDWebImage
                // method could be used to retrieve errors and display them instead
                
                beforeEach {
                    subject.imageURL = URL(string: "https://j5.blank.man.net")
                    
                    _ = subject.view
                }
                
                // Note: In order to fully test out the usage of SDWebImage image replacement (temp -> image)
                // SDWebImage will need to be fully mocked out using protocols. Due to time restrictions,
                // this is an exercise that can be executed at a later time.
                
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
