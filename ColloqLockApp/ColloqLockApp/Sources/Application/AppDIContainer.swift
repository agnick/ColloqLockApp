import Foundation

@MainActor
final class AppDIContainer {
    
    // MARK: - Init
    
    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }
    
    // MARK: - Services
    
    let appRouter: AppRouter
    let authService: AuthService = AuthServiceImpl()
    let colloqService: ColloqService = ColloqServiceImpl()
    
    // MARK: - Factories
    
    lazy var authorizationFactory: AuthorizationFactory = {
        AuthorizationFactoryImpl()
    }()
    
    lazy var colloquiumJoinFactory: ColloquiumJoinFactory = {
        ColloquiumJoinFactoryImpl(externalDeps: ColloquiumJoinExternalDeps(
            appRouter: appRouter, colloqFactory: colloqFactory
        ))
    }()
    
    lazy var colloquiumCreationFactory: ColloqCreationFactory = {
        ColloqCreationFactoryImpl(externalDeps: ColloqCreationExternalDeps())
    }()
    
    lazy var profileFactory: ProfileFactory = {
        ProfileFactoryImpl(externalDeps: ProfileExternalDeps(
            authService: authService,
            appRouter: appRouter,
            authorizationFactory: authorizationFactory,
            colloquiumJoinFactory: colloquiumJoinFactory,
            colloqCreationFactory: colloquiumCreationFactory
        ))
    }()
    
    lazy var summarizeFactory: SummarizeFactory = {
        SummarizeFactoryImpl(
            externalDeps: SummarizeExternalDeps(
                appRouter: appRouter,
                profileFactory: profileFactory
            ))
    }()
    
    lazy var loadingFactory: LoadingFactory = {
        LoadingFactoryImpl(externalDeps: LoadingExternalDeps(
            appRouter: appRouter,
            summarizeFactory: summarizeFactory
        ))
    }()
    
    lazy var colloqFactory: ColloqFactory = {
        ColloqFactoryImpl(externalDeps: ColloqExternalDeps(
            appRouter: appRouter,
            colloqService: colloqService
        ))
    }()
}

