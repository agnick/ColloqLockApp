@MainActor
protocol ColloquiumJoinRouter {
    func routeTo(_ destination: ColloquiumJoinRouterDestination)
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
    
    func routeTo(_ destination: ColloquiumJoinRouterDestination) {
        switch destination {
        case .colloquium(let colloquiumId):
            let colloqVC = colloqFactory.makeColloqScreen(id: colloquiumId)
            appRouter.setRoot(colloqVC, animated: true)
        }
    }
    
    // MARK: - Private Properties
    
    private let appRouter: AppRouter
    private let colloqFactory: ColloqFactory
}

