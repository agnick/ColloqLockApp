import SwiftUI

@MainActor
final class ColloqViewModelImpl: ColloqViewModel {
    
    // MARK: - Internal Properties
    @Published var questions: [ColloqQuestionModel] = []
    @Published var currentIndex: Int = 0
    @Published var answers: [ColloqAnswerModel] = []
    @Published var isLoading: Bool = true
    @Published var remainingTime: TimeInterval = 3600
    
    private var id: String
    private let quizDuration: TimeInterval = 3600
    private var startDate: Date?
    private var timer: Timer?
    
    var currentQuestion: String {
        return  questions.count > currentIndex ? questions[currentIndex].text : "fff"
    }
    
    var currentType: ColloqQuestionType {
        return questions.count > currentIndex ? questions[currentIndex].type : .open
    }
    
    // MARK: - Init
    
    init(interactor: ColloqInteractor, router: ColloqRouter, id: String) {
        self.interactor = interactor
        self.router = router
        self.id = id
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
        saveAnswer(index: currentIndex)
    }
    
    func markUnanswered() {
        questions[currentIndex].isAnswered = false
        saveAnswer(index: currentIndex)
    }
    
    func onAppear() {
        onAppearTask?.cancel()
        isLoading = true
        
        onAppearTask = Task {
            defer { isLoading = false }
            do {
                guard let colloqQuestions = try await interactor.loadQuestions() else { return }
                questions = colloqQuestions

                let savedAnswers = try await interactor.loadAnswers(for: id)
                
                self.answers = if let savedAnswers {
                    savedAnswers
                } else {
                    questions.map { q in
                        switch q.type {
                        case .open: .open("")
                        case .pick2: .pick2(nil)
                        case .pick4: .pick4([])
                        }
                    }
                }
                
                if startDate == nil {
                    startDate = Date()
                    startTimer()
                }
                
            } catch {
                print("Load data error: \(error)")
            }
        }
    }
    
    private func saveAnswer(index: Int) {
        let answer = answers[index]
        Task {
            do {
                try await interactor.saveAnswer(for: id, index: index, answer: answer)
            } catch {
                print("Failed to save answer: \(error)")
            }
        }
    }
    
    func onDisappear() {
        timer?.invalidate()
    }
    
    private func startTimer() {
        updateRemainingTime()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateRemainingTime()
            }
        }
    }
    
    private func updateRemainingTime() {
        guard let startDate else { return }
        let elapsed = Date().timeIntervalSince(startDate)
        let left = max(quizDuration - elapsed, 0)
        remainingTime = left
        
        if left <= 0 {
            timer?.invalidate()
        }
    }
    
    // MARK: - Private Properties
    
    private let interactor: ColloqInteractor
    private let router: ColloqRouter
    
    private var onAppearTask: Task<Void, Never>?
}
