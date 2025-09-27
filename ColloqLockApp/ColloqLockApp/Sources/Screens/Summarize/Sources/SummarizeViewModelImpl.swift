import SwiftUI

@MainActor
final class SummarizeViewModelImpl: SummarizeViewModel {
    // MARK: - Internal properties
    @Published var testQuestionsTitles: [String] = []
    @Published var testAnswersTitles: [String] = []
    @Published var openQuestionsTitles: [String] = []
    @Published var openAnswersTitles: [String] = []
    
    // MARK: - Initialization
    init(interactor: SummarizeInteractor, router: SummarizeRouter) {
        self.interactor = interactor
        self.router = router
        
        Task {
            await loadData()
        }
    }
    
    // MARK: - Public
    
    func sendAnswers() {
        Task {
            do {
                let testAnswers = try await interactor.getTestAnswers()
                let openAnswers = try await interactor.getOpenAnswers()
                
                try await interactor.saveAnswers(
                    testAnswers: testAnswers,
                    openAnswers: openAnswers
                )
                
                router.routeToProfileScreen()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Private functions
    private func loadData() async {
        do {
            let questions = try await interactor.getTestQuestions()
            let answers = try await interactor.getTestAnswers()
            let openQuestions = try await interactor.getOpenQuestions()
            let openAnswers = try await interactor.getOpenAnswers()
            
            self.testQuestionsTitles = questions.map(\.question)
            self.testAnswersTitles = mapAnswers(answers: answers, questions: questions)
            self.openQuestionsTitles = openQuestions.map(\.question)
            self.openAnswersTitles = mapOpenAnswers(openAnswers)
        } catch {
            print("Ошибка загрузки данных: \(error)")
        }
    }
    
    private func mapAnswers(answers: [TestAnswerDto], questions: [TestQuestionDto]) -> [String] {
        return answers.compactMap { answer in
            guard let option = answer.optionAnswer,
                  let question = questions.first(where: { $0.id == answer.questionId }) else {
                return "Пропущено"
            }
            return "\(question.options[option])"
        }
    }
    
    private func mapOpenAnswers(_ answers: [OpenAnswerDto]) -> [String] {
        return answers.map { answerDto in
            if let answer = answerDto.answer {
                return answer
            } else {
                return "Пропущено"
            }
        }
    }
    
    // MARK: - Private properties
    private let interactor: SummarizeInteractor
    private let router: SummarizeRouter
}
