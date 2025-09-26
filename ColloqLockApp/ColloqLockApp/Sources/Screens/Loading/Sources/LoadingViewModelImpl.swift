import SwiftUI

@MainActor
protocol LoadingViewModel: ObservableObject {
    var isLoading: Bool { get }
}

@MainActor
final class LoadingViewModelImpl: LoadingViewModel {
    
    // MARK: - Internal Properties
    
    @Published var isLoading: Bool = true
    
    // MARK: - Init
    
    init(interactor: LoadingInteractor, router: LoadingRouter) {
        self.interactor = interactor
        self.router = router
        startStatusChecking()
    }
    
    // MARK: - Private Methods
    
    private func startStatusChecking() {
        Task {
            do {
                let isStarted = try await interactor.checkColloquiumStatus()
                if isStarted {
                    await MainActor.run {
                        router.routeToSummarizeScreen("test_colloquium_id")
                    }
                }
            } catch {
                await MainActor.run {
                    router.routeToErrorScreen(error)
                }
            }
            isLoading = false
        }
    }
    
    // MARK: - Private Properties
    
    private let interactor: LoadingInteractor
    private let router: LoadingRouter
}
