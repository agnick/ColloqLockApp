import SwiftUI

@MainActor
protocol ProfileFactory {
    func makeProfileScreen() -> UIViewController
}

struct ProfileFactoryImpl: ProfileFactory {
    
    // MARK: - Init

    init(externalDeps: ProfileExternalDeps) {
        self.externalDeps = externalDeps
    }
    
    // MARK: - Public Methods

    func makeProfileScreen() -> UIViewController {
        let router = ProfileRouterImpl(
            appRouter: externalDeps.appRouter,
            authorizationFactory: externalDeps.authorizationFactory,
            colloquiumJoinFactory: externalDeps.colloquiumJoinFactory,
            colloqCreationFactory: externalDeps.colloqCreationFactory
        )
        let interactor = ProfileInteractorImpl(authService: externalDeps.authService)
        let viewModel = ProfileViewModelImpl(interactor: interactor, router: router)
        let rootView = ProfileView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private Properties

    private let externalDeps: ProfileExternalDeps
}
