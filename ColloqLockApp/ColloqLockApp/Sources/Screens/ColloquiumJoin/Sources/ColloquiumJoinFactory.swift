import SwiftUI

@MainActor
protocol ColloquiumJoinFactory {
    func makeColloquiumJoinScreen() -> UIViewController
}

struct ColloquiumJoinFactoryImpl: ColloquiumJoinFactory {
    
    // MARK: - Init
    
    init(externalDeps: ColloquiumJoinExternalDeps) {
        self.externalDeps = externalDeps
    }
    
    // MARK: - Public Methods
    
    func makeColloquiumJoinScreen() -> UIViewController {
        let interactor = ColloquiumJoinInteractorImpl()
        let viewModel = ColloquiumJoinViewModelImpl(interactor: interactor)
        let rootView = ColloquiumJoinView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private Properties
    
    private let externalDeps: ColloquiumJoinExternalDeps
}
