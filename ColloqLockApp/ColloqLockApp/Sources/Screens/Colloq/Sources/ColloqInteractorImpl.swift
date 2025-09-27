import Foundation

protocol ColloqInteractor {
    func loadQuestions() async throws -> [ColloqQuestionModel]?
    func loadAnswers(for id: String) async throws -> [ColloqAnswerModel]?
    func saveAnswer(for id: String, index: Int, answer: ColloqAnswerModel) async throws
}

final class ColloqInteractorImpl: ColloqInteractor {
    
    private let colloqService: ColloqService
    private let userID: String
    
    init(colloqService: ColloqService, userID: String) {
        self.colloqService = colloqService
        self.userID = userID
    }
    
    func loadQuestions() async throws -> [ColloqQuestionModel]? {
        try await colloqService.fetchQuestions()
    }
    
    func loadAnswers(for id: String) async throws -> [ColloqAnswerModel]? {
        try await colloqService.fetchAnswers(userId: id)
    }
    
    func saveAnswer(for id: String, index: Int, answer: ColloqAnswerModel) async throws {
        try await colloqService.saveAnswer(userId: id, index: index, answer: answer)
    }
    
    
}
