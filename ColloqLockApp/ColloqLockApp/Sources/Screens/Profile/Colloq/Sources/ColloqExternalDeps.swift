import Foundation

public struct ColloqExternalDeps {
    let authService: AuthService
    let appRouter: AppRouter
    let authorizationFactory: AuthorizationFactory
    
    init(authService: AuthService, appRouter: AppRouter, authorizationFactory: AuthorizationFactory) {
        self.authService = authService
        self.appRouter = appRouter
        self.authorizationFactory = authorizationFactory
    }
}
