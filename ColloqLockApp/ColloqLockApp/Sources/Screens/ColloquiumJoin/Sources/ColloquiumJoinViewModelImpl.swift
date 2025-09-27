import SwiftUI

@MainActor
final class ColloquiumJoinViewModelImpl: ColloquiumJoinViewModel {
    
    // MARK: - Internal Properties
    
    @Published var code: String = ""
    
    // MARK: - Init
    
    init(interactor: ColloquiumJoinInteractor, router: ColloquiumJoinRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Public Methods
    
    func joinColloquium() {
        guard !code.isEmpty else {
            ToastService.showError(ColloquiumJoinError.invalidCode.description)
            return
        }
        
        joinColloquiumTask = Task {
            do {
                let colloqId = try await interactor.validateColloqiumCode(code)
                router.routeTo(.colloquium(colloqId))
            } catch let error as ColloquiumJoinError {
                ToastService.showError(error.description)
                print(error)
            } catch {
                ToastService.showError(ColloquiumJoinError.unknown.description)
                print(error)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let interactor: ColloquiumJoinInteractor
    private let router: ColloquiumJoinRouter
    
    private var joinColloquiumTask: Task<Void, Error>?
}
