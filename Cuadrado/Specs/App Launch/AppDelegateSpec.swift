import Quick
import Nimble
@testable import Cuadrado

class AppDelegateSpec: QuickSpec {
    override func spec() {
        describe("AppDelegate") {
            var subject: AppDelegate!

            beforeEach {
                subject = AppDelegate()
            }

            describe("<UIApplicationDelegate>") {
                describe("#application(_:didFinishLaunchingWithOptions:)") {
                    var didFinishLaunching: Bool!
                    
                    beforeEach {
                        didFinishLaunching = subject.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
                    }
                    
                    it("always returns true") {
                        expect(didFinishLaunching).to(beTruthy())
                    }
                }
            }
        }
    }
}
