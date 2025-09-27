import FirebaseFirestore
import FirebaseAuth

protocol ColloqService {
    func fetchQuestions() async throws -> [ColloqQuestionModel]
    func fetchAnswers(userId: String) async throws -> [ColloqAnswerModel]?
    func saveAnswer(userId: String, index: Int, answer: ColloqAnswerModel) async throws
}

final class ColloqServiceImpl: ColloqService {
    
    private let db = Firestore.firestore()
    
    // MARK: - Questions
    
    func fetchQuestions() async throws -> [ColloqQuestionModel] {
        let snapshot = try await db.collection("questions").getDocuments()
        let questions: [TestQuestionDto] = try snapshot.documents.compactMap { doc in
            try doc.data(as: TestQuestionDto.self)
        }
        
        return questions
    }
    
    // MARK: - Answers
    
    func fetchAnswers(userId: String) async throws -> [ColloqAnswerModel]? {
        let doc = try await db.collection("answers").document(userId).getDocument()
        
        guard let data = doc.data(),
              let answersArray = data["answers"] as? [[String: Any]] else {
            return nil
        }
        
        return answersArray.compactMap { dict in
            guard let type = dict["type"] as? String else { return nil }
            
            switch type {
            case "open":
                return .open(dict["value"] as? String ?? "")
            case "pick2":
                return .pick2(dict["value"] as? Int)
            case "pick4":
                if let values = dict["value"] as? [Int] {
                    return .pick4(Set(values))
                }
                return .pick4([])
            default:
                return nil
            }
        }
    }
    
    func saveAnswer(userId: String, index: Int, answer: ColloqAnswerModel) async throws {
        let docRef = db.collection("answers").document(userId)
        let snapshot = try await docRef.getDocument()
        
        var existingAnswers: [[String: Any]] = []
        if let data = snapshot.data(),
           let stored = data["answers"] as? [[String: Any]] {
            existingAnswers = stored
        }
        
        let mapped: [String: Any]
        switch answer {
        case .open(let text):
            mapped = ["questionIndex": index, "type": "open", "value": text]
        case .pick2(let value):
            mapped = ["questionIndex": index, "type": "pick2", "value": value as Any]
        case .pick4(let values):
            mapped = ["questionIndex": index, "type": "pick4", "value": Array(values)]
        }
        
        if let existingIndex = existingAnswers.firstIndex(where: { ($0["questionIndex"] as? Int) == index }) {
            existingAnswers[existingIndex] = mapped
        } else {
            existingAnswers.append(mapped)
        }
        
        try await docRef.setData([
            "answers": existingAnswers,
            "timestamp": FieldValue.serverTimestamp()
        ])
    }
}




