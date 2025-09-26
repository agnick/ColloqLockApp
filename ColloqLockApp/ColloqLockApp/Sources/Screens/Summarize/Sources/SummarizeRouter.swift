@MainActor
protocol SummarizeRouter {
    func backToColloq()
    func routeToProfileScreen()
}

final class SummarizeRouterImpl: SummarizeRouter {
    // MARK: - Initialization
    init(appRouter: AppRouter, profileFactory: ProfileFactory) {
        self.appRouter = appRouter
        self.profileFactory = profileFactory
    }
    
    // MARK: - Public funtions
    func backToColloq() {
        //TODO: Route to colloq on endColloq button
    }
    
    func routeToProfileScreen() {
        let profileVC = profileFactory.makeProfileScreen()
        appRouter.setRoot(profileVC, animated: true)
    }
    
    // MARK: - Private properties
    private let appRouter: AppRouter
    private let profileFactory: ProfileFactory
}

