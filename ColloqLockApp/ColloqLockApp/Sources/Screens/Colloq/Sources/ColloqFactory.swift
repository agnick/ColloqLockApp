import SwiftUI

@MainActor
protocol ColloqFactory {
    func makeColloqScreen(id: String) -> UIViewController
}

struct ColloqFactoryImpl: ColloqFactory {
    
    // MARK: - Init
    
    init(externalDeps: ColloqExternalDeps) {
        self.externalDeps = externalDeps
    }
    
    // MARK: - Public Methods
    
    func makeColloqScreen(id: String) -> UIViewController {
        let router = ColloqRouterImpl(
            appRouter: externalDeps.appRouter
        )
        let interactor = ColloqInteractorImpl(colloqService: externalDeps.colloqService, userID: id)
        let viewModel = ColloqViewModelImpl(interactor: interactor, router: router, id: id)
        let rootView = ColloqView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private Properties
    
    private let externalDeps: ColloqExternalDeps
}
