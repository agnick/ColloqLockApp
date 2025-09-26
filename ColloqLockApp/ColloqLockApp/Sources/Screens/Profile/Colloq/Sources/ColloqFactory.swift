import SwiftUI

@MainActor
protocol ColloqFactory {
    func makeColloqScreen() -> UIViewController
}

struct ColloqFactoryImpl: ColloqFactory {
    
    // MARK: - Init
    
    init(externalDeps: ColloqExternalDeps) {
        self.externalDeps = externalDeps
    }
    
    // MARK: - Public Methods
    
    func makeColloqScreen() -> UIViewController {
        let router = ColloqRouterImpl(
            appRouter: externalDeps.appRouter,
            authorizationFactory: externalDeps.authorizationFactory
        )
        let interactor = ColloqInteractorImpl(authService: externalDeps.authService)
        
        let questions = interactor.loadQuestions()
        
        let viewModel = ColloqViewModelImpl(interactor: interactor, router: router, questions: questions)
        let rootView = ColloqView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private Properties
    
    private let externalDeps: ColloqExternalDeps
}
