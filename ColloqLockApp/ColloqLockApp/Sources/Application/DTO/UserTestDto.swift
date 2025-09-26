import Foundation

struct UserTestDto: Codable {
    let id: String
    let userId: String
    let testId: String
    let submittedAt: Date
    let answers: AnswersDto
    let teacherReview: TeacherReviewDto?
}

struct TeacherReviewDto: Codable {
    let checkedBy: String
    let checkedAt: Date
    let explanation: String?
    let grade: Int?
}
