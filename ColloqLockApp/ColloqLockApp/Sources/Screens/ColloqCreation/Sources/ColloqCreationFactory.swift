import SwiftUI

@MainActor
protocol ColloqCreationFactory {
    func makeAuthorizationScreen() -> UIViewController
}

struct ColloqCreationFactoryImpl: ColloqCreationFactory {
    
    // MARK: - Init

    init(externalDeps: ColloqCreationExternalDeps) {
        self.externalDeps = externalDeps
    }
    
    // MARK: - Public Methods

    func makeAuthorizationScreen() -> UIViewController {
        let interactor = AuthorizationInteractorImpl()
        let viewModel = AuthorizationViewModelImpl(interactor: interactor)
        let rootView = AuthorizationView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private Properties

    private let externalDeps: ColloqCreationExternalDeps
}
