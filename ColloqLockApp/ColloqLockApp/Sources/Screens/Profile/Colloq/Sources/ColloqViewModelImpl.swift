import SwiftUI

@MainActor
final class ColloqViewModelImpl: ColloqViewModel {
    
    // MARK: - Internal Properties
    @Published var questions: [ColloqQuestionModel]
    @Published var currentIndex: Int = 0
    @Published var answers: [ColloqAnswerModel]
    
    var currentQuestion: String {
        return questions[currentIndex].text
    }
    
    var currentType: ColloqQuestionType {
        return questions[currentIndex].type
    }
    
    // MARK: - Init
    
    init(interactor: ColloqInteractor, router: ColloqRouter, questions: [ColloqQuestionModel]) {
        self.interactor = interactor
        self.router = router
        self.questions = questions
        
        self.answers = questions.map { question in
            switch question.type {
            case .open: return .open("")
            case .pick2: return .pick2(nil)
            case .pick4: return .pick4([])
            }
        }
    }
    
    // MARK: - Public Methods
    
    func goNext() {
        currentIndex = (currentIndex + 1) % questions.count
    }
    
    func goBack() {
        if currentIndex == 0 {
            currentIndex = questions.count - 1
        } else {
            currentIndex -= 1
        }
    }
    
    func goToIndex(index: Int) {
        currentIndex = index
    }
    
    func markAnswered() {
        questions[currentIndex].isAnswered = true
    }
    
    func markUnanswered() {
        questions[currentIndex].isAnswered = true
    }
    
    // MARK: - Private Properties
    
    private let interactor: ColloqInteractor
    private let router: ColloqRouter
}
