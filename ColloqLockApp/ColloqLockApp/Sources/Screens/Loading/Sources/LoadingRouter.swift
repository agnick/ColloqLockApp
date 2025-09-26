import SwiftUI

@MainActor
protocol LoadingRouter {
    func routeToSummarizeScreen(_ colloquiumId: String)
    func routeToErrorScreen(_ error: Error)
}

final class LoadingRouterImpl: LoadingRouter {
    
    // MARK: - Init
    
    init(appRouter: AppRouter, summarizeFactory: SummarizeFactory) {
        self.appRouter = appRouter
        self.summarizeFactory = summarizeFactory
    }
    
    // MARK: - Public Methods
    
    func routeToSummarizeScreen(_ colloquiumId: String) {
        let summarizeVC = summarizeFactory.makeSummarizeScreen(testId: "")
        appRouter.setRoot(summarizeVC, animated: true)
    }
    
    func routeToErrorScreen(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        print("Error: \(error)")
    }
    
    // MARK: - Private Properties
    
    private let appRouter: AppRouter
    private let summarizeFactory: SummarizeFactory
}
