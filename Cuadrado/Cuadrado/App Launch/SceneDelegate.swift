import UIKit
import Capsule
import Utensils

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Public  properties
    
    var storyboardBuilder: StoryboardBuilderProtocol = StoryboardBuilder()
    var appLaunchLoader: AppLaunchLoaderProtocol = AppLaunchLoader()
    var appLaunchViewController: AppLaunchViewController?
    
    // MARK: - <UIWindowSceneDelegate>
    
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        
        appLaunchViewController = AppLaunchViewController { [weak self] in
            self?.appLaunchLoader.load { result in
                self?.presentCuadradoVieController(result: result)
            }
        }
        
        appLaunchViewController?.customLaunchView = CustomAppLaunchLoadingView()
        
        window?.rootViewController = appLaunchViewController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Private methods
    
    private func presentCuadradoVieController(result: Result<[Employee], APIClientError>) {
        let cuadradoViewController = storyboardBuilder.buildInitialViewController(name: "CuadradoViewController") as! CuadradoViewController
        
        cuadradoViewController.modalPresentationStyle = .fullScreen
        cuadradoViewController.employeesResult = result
        
        window?.rootViewController?.present(cuadradoViewController, animated: false)
    }
}
