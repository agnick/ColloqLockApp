import Foundation

public struct SummarizeExternalDeps {
    let appRouter: AppRouter
    let profileFactory: ProfileFactory
    
    init(appRouter: AppRouter, profileFactory: ProfileFactory) {
        self.appRouter = appRouter
        self.profileFactory = profileFactory
    }
}
