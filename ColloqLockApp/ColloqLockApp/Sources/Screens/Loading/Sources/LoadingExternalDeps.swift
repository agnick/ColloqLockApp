import Foundation

public struct LoadingExternalDeps {
    let appRouter: AppRouter
    let summarizeFactory: SummarizeFactory
    
    init(appRouter: AppRouter, summarizeFactory: SummarizeFactory) {
        self.appRouter = appRouter
        self.summarizeFactory = summarizeFactory
    }
}
