import Foundation

protocol ColloquiumJoinInteractor {
    func joinColloquium(with code: String) async throws -> String
}

final class ColloquiumJoinInteractorImpl: ColloquiumJoinInteractor {
    
    // MARK: - Mock Data
    
    private let mockColloquiums = [
        "123456": "colloquium_1",
        "ABCDEF": "colloquium_2",
        "789012": "colloquium_3"
    ]
    
    // MARK: - Public Methods
    
    func joinColloquium(with code: String) async throws -> String {
        // Имитация сетевой задержки
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда
        
        let cleanedCode = code.uppercased().trimmingCharacters(in: .whitespaces)
        
        guard cleanedCode.count == 4 else {
            throw ColloquiumJoinError.invalidCode
        }
        
        guard let colloquiumId = mockColloquiums[cleanedCode] else {
            throw ColloquiumJoinError.codeNotFound
        }
        
        return colloquiumId
    }
}

