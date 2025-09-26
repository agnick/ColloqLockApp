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
        let viewModel = SummarizeViewModelImpl(interactor: interactor)
        let rootView = SummarizeView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
    
    // MARK: - Private properties
    private let externalDeps: SummarizeExternalDeps
}
