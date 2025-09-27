import Foundation

protocol ColloqInteractor {
    func loadQuestions() async throws -> [ColloqQuestionModel]?
}

final class ColloqInteractorImpl: ColloqInteractor {
    
    func loadQuestions() async throws -> [ColloqQuestionModel]? {
        return [
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["Вариант 1Вариант 1Вариант 1", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil),
            ColloqQuestionModel(type: .pick2, text: "Выбери один вариант", options: ["Вариант 1", "Вариант 2"]),
            ColloqQuestionModel(type: .pick4, text: "Выбери несколько вариантов", options: ["A", "B", "C", "D"]),
            ColloqQuestionModel(type: .open, text: "Расскажи о себе", options: nil)
        ]
    }
    
    func submitAnswers(_ answers: [ColloqAnswerModel]) async throws {

    }
}
