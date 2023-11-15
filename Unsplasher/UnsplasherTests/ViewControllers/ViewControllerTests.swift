import Quick
import Nimble
import UnsplashPhotoPicker
@testable import Unsplasher

final class ViewControllerTests: QuickSpec {
    override class func spec() {
        describe("ViewController") {
            var subject: ViewController!
            
            beforeEach {
                subject = ViewControllerBuilder().build(name: "Main")
            }
            
            it("has a unsplash photo picker configuration") {
                let expectedConfig = UnsplashPhotoPickerConfiguration(accessKey: Constants.Unsplash.AccessKey,
                                                                      secretKey: Constants.Unsplash.SecretKey)
                
                expect(subject.unsplashPhotoPickerConfiguration.accessKey).to(equal(expectedConfig.accessKey))
                expect(subject.unsplashPhotoPickerConfiguration.secretKey).to(equal(expectedConfig.secretKey))
            }
            
            describe("when the view loads") {
                beforeEach {
                    _ = subject.view
                }
                
                it("creates an unsplash photo picker") {
                    expect(subject.unsplashPhotoPicker).toNot(beNil())
                }
                
                it("adds the unsplash photo picker view to the main view") {
                    expect(subject.children).to(contain(subject.unsplashPhotoPicker))
                    expect(subject.view.subviews).to(contain(subject.unsplashPhotoPicker.view))
                }
                
                // Note: The constraints could also be tested, but due to time constraints this is an
                // exercise that can be done at a later time.
                
                it("sets the subject as the delegate of the unsplash photo picker") {
                    expect(subject.unsplashPhotoPicker.photoPickerDelegate === subject).to(beTruthy())
                }
                
                it("hides the cancel button from the unsplash photo picker") {
                    expect(subject.unsplashPhotoPicker.shouldHideCancelButton).to(beTruthy())
                }
                
                describe("<UnsplashPhotoPickerDelegate>") {
                    describe("#unsplashPhotoPicker(_:didSelectPhotos:") {
                        // Note: Since UnsplashPhoto is unable to be initalized without actually decoding a JSON
                        // The test for this will be executed at a later date.  A quick fix could be to create
                        // a "vanilla" init() for it in the forked repo.
                    }
                }
            }
        }
    }
}
