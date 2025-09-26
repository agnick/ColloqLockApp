import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Internal Properties

    var window: UIWindow?
    
    // MARK: - Public Methods

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let diContainer = AppDIContainer(appRouter: AppRouterImpl(window: window))
                
        diContainer.authService.start { state in
            switch state {
            case .signedOut:
                let vc = diContainer.authorizationFactory.makeAuthorizationScreen()
                diContainer.appRouter.setRoot(vc, animated: true)
            case .signedIn:
                let vc = diContainer.summarizeFactory.makeSummarizeScreen(testId: "2oxnecb2uxuGbkPAbTwZ") //diContainer.profileFactory.makeProfileScreen()
                diContainer.appRouter.setRoot(vc, animated: true)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

