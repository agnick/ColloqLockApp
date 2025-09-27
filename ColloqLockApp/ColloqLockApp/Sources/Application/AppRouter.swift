import UIKit

protocol AppRouter {
    func setRoot(_ vc: UIViewController, animated: Bool)
    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, animated: Bool)
    func close(animated: Bool)
}

final class AppRouterImpl: AppRouter {
    
    // MARK: - Init
        
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
        
    // MARK: - Public Methods

    func setRoot(_ vc: UIViewController, animated: Bool = true) {
        navigationController.setViewControllers([vc], animated: animated)
    }

    func push(_ vc: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(vc, animated: animated)
    }

    func present(_ vc: UIViewController, animated: Bool = true) {
        navigationController.present(vc, animated: animated)
    }

    func close(animated: Bool = true) {
        if navigationController.presentedViewController != nil {
            navigationController.dismiss(animated: animated)
        } else {
            navigationController.popViewController(animated: animated)
        }
    }
    
    // MARK: - Private Properties
    
    private let window: UIWindow
    private let navigationController: UINavigationController
}
