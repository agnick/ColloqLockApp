import SwiftUI

@MainActor
final class ColloquiumJoinViewModelImpl: ColloquiumJoinViewModel {
    
    // MARK: - Internal Properties
    
    @Published var code: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isErrorMessagePresented: Bool = false
    
    // MARK: - Init
    
    init(interactor: ColloquiumJoinInteractor, router: ColloquiumJoinRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Public Methods
    
    func joinColloquium() {
        guard !code.isEmpty else {
            errorMessage = "Введите код"
            isErrorMessagePresented = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        isErrorMessagePresented = false
        
        Task {
            do {
                let colloquiumId = try await interactor.joinColloquium(with: code)
                router.routeTo(.colloquium(colloquiumId))
            } catch let error as ColloquiumJoinError {
                errorMessage = error.title
                isErrorMessagePresented = true
            } catch {
                errorMessage = ColloquiumJoinStrings.unknownError
                isErrorMessagePresented = true
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Private Properties
    
    private let interactor: ColloquiumJoinInteractor
    private let router: ColloquiumJoinRouter
}
