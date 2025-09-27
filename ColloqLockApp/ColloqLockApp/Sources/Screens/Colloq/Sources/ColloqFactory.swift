import SwiftUI

@MainActor
protocol ColloqFactory {
    func makeColloqScreen(userId: String, testId: String) -> UIViewController
}

struct ColloqFactoryImpl: ColloqFactory {
    
    // MARK: - Init
    
    init(externalDeps: ColloqExternalDeps) {
        self.externalDeps = externalDeps
    }
    
    // MARK: - Public Methods
    
    func makeColloqScreen(userId: String, testId: String) -> UIViewController {
        let router = ColloqRouterImpl(
            appRouter: externalDeps.appRouter
        )
        let interactor = ColloqInteractorImpl(colloqService: externalDeps.colloqService, testId: testId, userId: userId)
        let viewModel = ColloqViewModelImpl(interactor: interactor, router: router)
        let rootView = ColloqView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private Properties
    
    private let externalDeps: ColloqExternalDeps
}
