import SwiftUI

@MainActor
protocol SummarizeFactory {
    func makeSummarizeScreen(testId: String) -> UIViewController
}

struct SummarizeFactoryImpl: SummarizeFactory {
    // MARK: - Initialization
    init (externalDeps: SummarizeExternalDeps) {
        self.externalDeps = externalDeps
    }
    
    // MARK: - Public functions
    func makeSummarizeScreen(testId: String) -> UIViewController {
        let interactor = SummarizeInteractorImpl(testId: testId)
        let router = SummarizeRouterImpl(appRouter: externalDeps.appRouter, profileFactory: externalDeps.profileFactory)
        let viewModel = SummarizeViewModelImpl(interactor: interactor, router: router)
        let rootView = SummarizeView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private properties
    private let externalDeps: SummarizeExternalDeps
}
