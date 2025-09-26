@MainActor
protocol ColloqRouter {

}

final class ColloqRouterImpl: ColloqRouter {
    
    // MARK: - Init
    
    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }
    
    // MARK: - Public Methods

    // MARK: - Private Properties
    
    private let appRouter: AppRouter
}
