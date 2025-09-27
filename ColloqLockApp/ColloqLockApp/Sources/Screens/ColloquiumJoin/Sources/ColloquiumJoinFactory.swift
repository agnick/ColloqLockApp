import SwiftUI

@MainActor
protocol ColloquiumJoinFactory {
    func makeColloquiumJoinScreen(userId: String) -> UIViewController
}

struct ColloquiumJoinFactoryImpl: ColloquiumJoinFactory {
    
    // MARK: - Init
    
    init(externalDeps: ColloquiumJoinExternalDeps) {
        self.externalDeps = externalDeps
    }
    
    // MARK: - Public Methods
    
    func makeColloquiumJoinScreen(userId: String) -> UIViewController {
        let interactor = ColloquiumJoinInteractorImpl()
        let router = ColloquiumJoinRouterImpl(appRouter: externalDeps.appRouter, colloqFactory: externalDeps.colloqFactory)
        let viewModel = ColloquiumJoinViewModelImpl(interactor: interactor, router: router, userId: userId)
        let rootView = ColloquiumJoinView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private Properties
    
    private let externalDeps: ColloquiumJoinExternalDeps
}
