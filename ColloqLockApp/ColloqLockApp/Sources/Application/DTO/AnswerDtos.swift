import Foundation

struct TestAnswerDto: Codable {
    let questionId: String
    let optionAnswer: Int?
}

struct OpenAnswerDto: Codable {
    let questionId: String
    let answer: String?
}

struct AnswersDto: Codable {
    let testAnswers: [TestAnswerDto]
    let openAnswers: [OpenAnswerDto]
}
