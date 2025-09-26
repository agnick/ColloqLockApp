import Foundation

public struct ProfileExternalDeps {
    let authService: AuthService
    let appRouter: AppRouter
    let authorizationFactory: AuthorizationFactory
    let colloquiumJoinFactory: ColloquiumJoinFactory
    let colloqCreationFactory: ColloqCreationFactory
    
    init(
        authService: AuthService,
        appRouter: AppRouter,
        authorizationFactory: AuthorizationFactory,
        colloquiumJoinFactory: ColloquiumJoinFactory,
        colloqCreationFactory: ColloqCreationFactory
    ) {
        self.authService = authService
        self.appRouter = appRouter
        self.authorizationFactory = authorizationFactory
        self.colloquiumJoinFactory = colloquiumJoinFactory
        self.colloqCreationFactory = colloqCreationFactory
    }
}
