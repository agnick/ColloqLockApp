@MainActor
protocol ColloquiumJoinRouter {
    func routeTo(_ destination: ColloquiumJoinRouterDestination, userId: String, testId: String)
}

enum ColloquiumJoinRouterDestination {
    case colloquium(String)
}

final class ColloquiumJoinRouterImpl: ColloquiumJoinRouter {
    
    // MARK: - Init
    
    init(
        appRouter: AppRouter,
        colloqFactory: ColloqFactory
    ) {
        self.appRouter = appRouter
        self.colloqFactory = colloqFactory
    }
    
    // MARK: - Public Methods
    
    func routeTo(_ destination: ColloquiumJoinRouterDestination, userId: String, testId: String) {
        switch destination {
        case .colloquium(let colloquiumId):
            let colloqVC = colloqFactory.makeColloqScreen(userId: userId, testId: testId)
            appRouter.setRoot(colloqVC, animated: true)
        }
    }
    
    // MARK: - Private Properties
    
    private let appRouter: AppRouter
    private let colloqFactory: ColloqFactory
}

