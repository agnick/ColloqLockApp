import Foundation

public struct ColloqExternalDeps {
    let appRouter: AppRouter
    let colloqService: ColloqService
    
    init(appRouter: AppRouter, colloqService: ColloqService) {
        self.appRouter = appRouter
        self.colloqService = colloqService
    }
}
