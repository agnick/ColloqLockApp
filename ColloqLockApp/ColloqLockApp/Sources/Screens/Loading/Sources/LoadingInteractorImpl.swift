import Foundation

protocol LoadingInteractor {
    func checkColloquiumStatus() async throws -> Bool
}

final class LoadingInteractorImpl: LoadingInteractor {
    
    func checkColloquiumStatus() async throws -> Bool {
        try await Task.sleep(nanoseconds: 2_000_000_000) // заглушка
        return true
    }
}
