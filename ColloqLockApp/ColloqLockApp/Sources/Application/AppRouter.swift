import UIKit

protocol AppRouter {
    func setRoot(_ vc: UIViewController, animated: Bool)
    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, on from: UIViewController?, animated: Bool)
    func dismiss(_ from: UIViewController?, animated: Bool)
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

    func present(_ vc: UIViewController, on from: UIViewController?, animated: Bool = true) {
        from?.present(vc, animated: animated)
    }

    func dismiss(_ from: UIViewController?, animated: Bool = true) {
        from?.dismiss(animated: animated)
    }
    
    // MARK: - Private Properties
    
    private let window: UIWindow
    private let navigationController: UINavigationController
}
