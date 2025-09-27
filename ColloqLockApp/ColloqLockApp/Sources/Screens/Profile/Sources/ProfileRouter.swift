@MainActor
protocol ProfileRouter {
    func routeTo(_ destination: ProfileRouterDestination)
}

enum ProfileRouterDestination {
    case colloqJoin
    case colloqCreation
}

final class ProfileRouterImpl: ProfileRouter {
    
    // MARK: - Init
    
    init(
        appRouter: AppRouter,
        authorizationFactory: AuthorizationFactory,
        colloquiumJoinFactory: ColloquiumJoinFactory,
        colloqCreationFactory: ColloqCreationFactory
    ) {
        self.appRouter = appRouter
        self.authorizationFactory = authorizationFactory
        self.colloquiumJoinFactory = colloquiumJoinFactory
        self.colloqCreationFactory = colloqCreationFactory
    }
    
    // MARK: - Public Methods
    
    func routeTo(_ destination: ProfileRouterDestination) {
        switch destination {
        case .colloqCreation:
            break
        case .colloqJoin:
            let colloqJoinVC = colloquiumJoinFactory.makeColloquiumJoinScreen()
            appRouter.push(colloqJoinVC, animated: true)
        }
    }
    
    // MARK: - Private Properties
    
    private let appRouter: AppRouter
    private let authorizationFactory: AuthorizationFactory
    private let colloquiumJoinFactory: ColloquiumJoinFactory
    private let colloqCreationFactory: ColloqCreationFactory
}
