import Quick
import Nimble
import Utensils
@testable import Cuadrado

class SceneDelegateSpec: QuickSpec {
    override func spec() {
        describe("SceneDelegate") {
            var subject: SceneDelegate!

            beforeEach {
                subject = SceneDelegate()
            }
            
            it("exists") {
                expect(subject).toNot(beNil())
            }

            describe("<UIWindowSceneDelegate>") {
                // Unable to test, because there is no way to init Scenes or session =(
                
//                describe("#scene(_:willConnectTo:, options:)") {
//                    beforeEach {
//                        subject.scene(UIWindowScene(),
//                                      willConnectTo: UISceneSession(),
//                                      options: UIScene.ConnectionOptions())
//                    }
//
//                    it("creates a window from the window scene with app launch view controller") {
//                        expect(subject.window?.rootViewController).to(beAnInstanceOf(AppLaunchViewController.self))
//                    }
//                }
            }
        }
    }
}
