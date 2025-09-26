@MainActor
protocol ColloqRouter {

}

final class ColloqRouterImpl: ColloqRouter {
    
    // MARK: - Init
    
    init(appRouter: AppRouter, authorizationFactory: AuthorizationFactory) {
        self.appRouter = appRouter
        self.authorizationFactory = authorizationFactory
    }
    
    // MARK: - Public Methods

    // MARK: - Private Properties
    
    private let appRouter: AppRouter
    private let authorizationFactory: AuthorizationFactory
}
