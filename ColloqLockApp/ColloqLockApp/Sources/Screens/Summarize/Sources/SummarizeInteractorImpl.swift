import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol SummarizeInteractor {
    func getTestQuestions() async throws -> [TestQuestionDto]
    func getTestAnswers() async throws -> [TestAnswerDto]
    func getOpenQuestions() async throws -> [OpenQuestionDto]
    func getOpenAnswers() async throws -> [OpenAnswerDto]
    func saveAnswers(testAnswers: [TestAnswerDto], openAnswers: [OpenAnswerDto]) async throws
}

final class SummarizeInteractorImpl: SummarizeInteractor {
    // MARK: - Initialization
    init(testId: String) {
        self.testId = testId
    }

    // MARK: - Public functions
    func getTestQuestions() async throws -> [TestQuestionDto] {
        let snapshot = try await firestore.collection("tests").document(testId).getDocument()
        guard let data = snapshot.data(),
              let questionsArray = data["testQuestions"] as? [[String: Any]] else { return [] }
        
        let questions: [TestQuestionDto] = questionsArray.compactMap { dict in
            guard
                let id = dict["id"] as? String,
                let question = dict["question"] as? String,
                let options = dict["options"] as? [String],
                let correctOption = dict["correctOption"] as? Int
            else {
                return nil
            }
            return TestQuestionDto(id: id, question: question, options: options, correctOption: correctOption)
        }
        return questions
    }

    func getTestAnswers() async throws -> [TestAnswerDto] {
        guard let userId else { return [] }
                
        let snapshot = try await firestore.collection("userTests")
            .whereField("testId", isEqualTo: testId)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        guard let doc = snapshot.documents.first,
              let answersDict = doc.data()["answers"] as? [String: Any],
              let testAnswersArray = answersDict["testAnswers"] as? [[String: Any]]
        else { return [] }
        
        return testAnswersArray.compactMap { dict in
            guard let questionId = dict["questionId"] as? String else { return nil }
            let optionAnswer = dict["optionAnswer"] as? Int
            return TestAnswerDto(questionId: questionId, optionAnswer: optionAnswer)
        }
    }

    func getOpenQuestions() async throws -> [OpenQuestionDto] {
        let snapshot = try await firestore.collection("tests").document(testId).getDocument()
        guard let data = snapshot.data(),
              let questionsArray = data["openQuestions"] as? [[String: Any]] else { return [] }
        
        return questionsArray.compactMap { dict in
            guard let id = dict["id"] as? String,
                  let question = dict["question"] as? String else { return nil }
            return OpenQuestionDto(id: id, question: question)
        }
    }

    func getOpenAnswers() async throws -> [OpenAnswerDto] {
        guard let userId else { return [] }
                
        let snapshot = try await firestore.collection("userTests")
            .whereField("testId", isEqualTo: testId)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        guard let doc = snapshot.documents.first,
              let answersDict = doc.data()["answers"] as? [String: Any],
              let openAnswersArray = answersDict["openAnswers"] as? [[String: Any]]
        else { return [] }
        
        return openAnswersArray.compactMap { dict in
            guard let questionId = dict["questionId"] as? String else { return nil }
            let answer = dict["answer"] as? String
            return OpenAnswerDto(questionId: questionId, answer: answer)
        }
    }
    
    func saveAnswers(
        testAnswers: [TestAnswerDto],
        openAnswers: [OpenAnswerDto]
    ) async throws {
        guard let userId else {
            throw NSError(
                domain: "SummarizeInteractor",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]
            )
        }
        
        let docRef = firestore.collection("userTests").document("\(testId)_\(userId)")
        
        let testAnswersData: [[String: Any]] = testAnswers.map { dto in
            var dict: [String: Any] = ["questionId": dto.questionId]
            if let option = dto.optionAnswer {
                dict["optionAnswer"] = option
            }
            return dict
        }
        
        let openAnswersData: [[String: Any]] = openAnswers.map { dto in
            var dict: [String: Any] = ["questionId": dto.questionId]
            if let answer = dto.answer {
                dict["answer"] = answer
            }
            return dict
        }
        
        let data: [String: Any] = [
            "testId": testId,
            "userId": userId,
            "answers": [
                "testAnswers": testAnswersData,
                "openAnswers": openAnswersData
            ],
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        do {
            try await docRef.setData(data, merge: true)
        } catch {
            throw error
        }
    }


    // MARK: - Private properties
    private let firestore = Firestore.firestore()
    private let testId: String
    private let userId: String? = Auth.auth().currentUser?.uid
}
