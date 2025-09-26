import Foundation

struct TestDto: Identifiable, Codable {
    let id: String
    let accessCode: UInt
    let testQuestions: [TestQuestionDto]
    let openQuestions: [OpenQuestionDto]
    var assignedAssistant: String? = nil
    let createdBy: String
    let endTime: Date
    let startTime: Date
    let maxGrade: Int
    let status: TestStatus
    let title: String 
}

enum TestStatus: String, Codable {
    case active
    case closed
    case draft
}
