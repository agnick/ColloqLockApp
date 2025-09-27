import SwiftUI

@MainActor
final class ColloquiumJoinViewModelImpl: ColloquiumJoinViewModel {
    
    // MARK: - Internal Properties
    
    @Published var code: String = ""
    var userId: String
    
    // MARK: - Init
    
    init(interactor: ColloquiumJoinInteractor, router: ColloquiumJoinRouter, userId: String) {
        self.interactor = interactor
        self.router = router
        self.userId = userId
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
                router.routeTo(.colloquium(colloqId), userId: userId, testId: colloqId)
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
