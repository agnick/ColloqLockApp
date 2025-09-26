import SwiftUI

@MainActor
protocol LoadingFactory {
    func makeLoadingScreen() -> UIViewController
}

struct LoadingFactoryImpl: LoadingFactory {
    
    // MARK: - Init
    
    init(externalDeps: LoadingExternalDeps) {
        self.externalDeps = externalDeps
    }
    
    // MARK: - Public Methods
    
    func makeLoadingScreen() -> UIViewController {
        let router = LoadingRouterImpl(
            appRouter: externalDeps.appRouter,
            summarizeFactory: externalDeps.summarizeFactory
        )
        let interactor = LoadingInteractorImpl()
        let viewModel = LoadingViewModelImpl(interactor: interactor, router: router)
        let rootView = LoadingView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private Properties
    
    private let externalDeps: LoadingExternalDeps
}
