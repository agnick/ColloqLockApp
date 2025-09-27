import Foundation

protocol ColloqInteractor {
    func loadQuestions() async throws -> [ColloqQuestionModel]?
    func loadAnswers() async throws -> [ColloqAnswerModel]?
    func saveAnswer(index: Int, answer: ColloqAnswerModel) async throws
}

final class ColloqInteractorImpl: ColloqInteractor {
    
    private let colloqService: ColloqService
    private let testId: String
    private let userId: String
    
    init(colloqService: ColloqService, testId: String, userId: String) {
        self.colloqService = colloqService
        self.testId = testId
        self.userId = userId
    }
    
    // MARK: - Load questions
    
    func loadQuestions() async throws -> [ColloqQuestionModel]? {
        async let testQuestions = colloqService.fetchTestQuestions(testId: testId)
        async let openQuestions = colloqService.fetchOpenQuestions(testId: testId)
        
        let (tests, opens) = try await (testQuestions, openQuestions)
        
        var result: [ColloqQuestionModel] = []
        
        result.append(contentsOf: tests.map { q in
            ColloqQuestionModel(
                type: .pick4,
                text: q.question,
                options: q.options,
                isAnswered: false
            )
        })

        result.append(contentsOf: opens.map { q in
            ColloqQuestionModel(
                type: .open,
                text: q.question,
                options: nil,
                isAnswered: false
            )
        })
        
        return result
    }
    
    // MARK: - Load answers
    
    func loadAnswers() async throws -> [ColloqAnswerModel]? {
        guard let answersDto = try await colloqService.fetchAnswers(userId: userId, testId: testId) else {
            return nil
        }
        
        var result: [ColloqAnswerModel] = []
        
        for testAnswer in answersDto.testAnswers {
            if let option = testAnswer.optionAnswer {
                result.append(.pick4([option]))
            } else {
                result.append(.pick4([]))
            }
        }
        
        for openAnswer in answersDto.openAnswers {
            result.append(.open(openAnswer.answer ?? ""))
        }
        
        return result
    }
    
    // MARK: - Save answer
    
    func saveAnswer(index: Int, answer: ColloqAnswerModel) async throws {
        switch answer {
        case .pick2(let opt):
            let dto = TestAnswerDto(questionId: "questionId\(index+1)", optionAnswer: opt)
            try await colloqService.saveAnswer(userId: userId, testId: testId , testAnswer: dto, openAnswer: nil)
        case .pick4(let set):
            let opt = set.first
            let dto = TestAnswerDto(questionId: "testQuestionId\(index+1)", optionAnswer: opt)
            try await colloqService.saveAnswer(userId: userId, testId: testId, testAnswer: dto, openAnswer: nil)
        case .open(let text):
            let dto = OpenAnswerDto(questionId: "questionId\(index+1)", answer: text)
            try await colloqService.saveAnswer(userId: userId, testId: testId, testAnswer: nil, openAnswer: dto)
        }
    }
}

