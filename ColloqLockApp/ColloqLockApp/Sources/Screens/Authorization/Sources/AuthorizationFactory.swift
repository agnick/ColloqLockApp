import SwiftUI

@MainActor
protocol AuthorizationFactory {
    func makeAuthorizationScreen() -> UIViewController
}

struct AuthorizationFactoryImpl: AuthorizationFactory {
    
    // MARK: - Public Methods

    func makeAuthorizationScreen() -> UIViewController {
        let interactor = AuthorizationInteractorImpl()
        let viewModel = AuthorizationViewModelImpl(interactor: interactor)
        let rootView = AuthorizationView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
}
