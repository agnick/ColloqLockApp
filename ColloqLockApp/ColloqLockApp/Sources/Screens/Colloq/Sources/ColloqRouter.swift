@MainActor
protocol ColloqRouter {
    func dismiss()
}

final class ColloqRouterImpl: ColloqRouter {
    
    // MARK: - Init
    
    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }
    
    // MARK: - Public Methods
    
    func dismiss() {
        appRouter.close(animated: true)
    }

    // MARK: - Private Properties
    
    private let appRouter: AppRouter
}
