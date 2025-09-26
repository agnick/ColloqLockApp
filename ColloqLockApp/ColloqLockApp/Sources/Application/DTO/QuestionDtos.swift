import Foundation

struct TestQuestionDto: Identifiable, Codable {
    let id: String
    let question: String
    let options: [String]
    let correctOption: Int
}

struct OpenQuestionDto: Identifiable, Codable {
    let id: String
    let question: String
}
