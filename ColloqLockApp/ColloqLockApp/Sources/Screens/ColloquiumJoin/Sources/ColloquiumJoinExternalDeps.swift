import Foundation

public struct ColloquiumJoinExternalDeps {
    let appRouter: AppRouter
    let colloqFactory: ColloqFactory
    
    init(
        appRouter: AppRouter,
        colloqFactory: ColloqFactory
    ) {
        self.appRouter = appRouter
        self.colloqFactory = colloqFactory
    }
}
