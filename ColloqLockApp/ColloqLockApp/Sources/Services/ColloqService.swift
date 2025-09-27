import FirebaseFirestore
import FirebaseAuth

protocol ColloqService {
    func fetchTestQuestions(testId: String) async throws -> [TestQuestionDto]
    func fetchOpenQuestions(testId: String) async throws -> [OpenQuestionDto]
    func fetchAnswers(userId: String, testId: String) async throws -> AnswersDto?
    func saveAnswer(userId: String, testId: String, testAnswer: TestAnswerDto?, openAnswer: OpenAnswerDto?) async throws
}

final class ColloqServiceImpl: ColloqService {
    
    private let db = Firestore.firestore()

    // MARK: - Fetch questions
    
    func fetchTestQuestions(testId: String) async throws -> [TestQuestionDto] {
        let doc = try await db.collection("tests").document(testId).getDocument()
        guard let data = doc.data(),
              let questionsArray = data["testQuestions"] as? [[String: Any]] else { return [] }
        
        return questionsArray.compactMap { dict in
            guard let id = dict["id"] as? String,
                  let question = dict["question"] as? String,
                  let options = dict["options"] as? [String],
                  let correctOption = dict["correctOption"] as? Int else { return nil }
            return TestQuestionDto(id: id, question: question, options: options, correctOption: correctOption)
        }
    }
    
    func fetchOpenQuestions(testId: String) async throws -> [OpenQuestionDto] {
        let doc = try await db.collection("tests").document(testId).getDocument()
        guard let data = doc.data(),
              let questionsArray = data["openQuestions"] as? [[String: Any]] else { return [] }
        
        return questionsArray.compactMap { dict in
            guard let id = dict["id"] as? String,
                  let question = dict["question"] as? String else { return nil }
            return OpenQuestionDto(id: id, question: question)
        }
    }
    
    // MARK: - Fetch answers
    
    func fetchAnswers(userId: String, testId: String) async throws -> AnswersDto? {
        let snapshot = try await db.collection("userTests")
            .whereField("testId", isEqualTo: testId)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        guard let doc = snapshot.documents.first,
              let answersDict = doc.data()["answers"] as? [String: Any] else { return nil }
        
        let testAnswersArray = answersDict["testAnswers"] as? [[String: Any]] ?? []
        let testAnswers = testAnswersArray.compactMap { dict -> TestAnswerDto? in
            guard let questionId = dict["questionId"] as? String else { return nil }
            let optionAnswer = dict["optionAnswer"] as? Int
            return TestAnswerDto(questionId: questionId, optionAnswer: optionAnswer)
        }
        
        let openAnswersArray = answersDict["openAnswers"] as? [[String: Any]] ?? []
        let openAnswers = openAnswersArray.compactMap { dict -> OpenAnswerDto? in
            guard let questionId = dict["questionId"] as? String else { return nil }
            let answer = dict["answer"] as? String
            return OpenAnswerDto(questionId: questionId, answer: answer)
        }
        
        return AnswersDto(testAnswers: testAnswers, openAnswers: openAnswers)
    }
    
    // MARK: - Save answers
    
    func saveAnswer(userId: String, testId: String, testAnswer: TestAnswerDto?, openAnswer: OpenAnswerDto?) async throws {
        let docRef = db.collection("userTests").document(userId)
        let snapshot = try await docRef.getDocument()
        
        var existingAnswers: [String: Any] = [:]
        if let data = snapshot.data(),
           let stored = data["answers"] as? [String: Any] {
            existingAnswers = stored
        }
        
        // testAnswers
        if let testAnswer {
            var testAnswers = existingAnswers["testAnswers"] as? [[String: Any]] ?? []
            if let index = testAnswers.firstIndex(where: { ($0["questionId"] as? String) == testAnswer.questionId }) {
                testAnswers[index] = ["questionId": testAnswer.questionId, "optionAnswer": testAnswer.optionAnswer as Any]
            } else {
                testAnswers.append(["questionId": testAnswer.questionId, "optionAnswer": testAnswer.optionAnswer as Any])
            }
            existingAnswers["testAnswers"] = testAnswers
        }
        
        // openAnswers
        if let openAnswer {
            var openAnswers = existingAnswers["openAnswers"] as? [[String: Any]] ?? []
            if let index = openAnswers.firstIndex(where: { ($0["questionId"] as? String) == openAnswer.questionId }) {
                openAnswers[index] = ["questionId": openAnswer.questionId, "answer": openAnswer.answer as Any]
            } else {
                openAnswers.append(["questionId": openAnswer.questionId, "answer": openAnswer.answer as Any])
            }
            existingAnswers["openAnswers"] = openAnswers
        }
        
        try await docRef.setData([
            "answers": existingAnswers,
            "submittedAt": FieldValue.serverTimestamp(),
            "testId": testId,
            "userId": userId
        ], merge: true)
    }
}
