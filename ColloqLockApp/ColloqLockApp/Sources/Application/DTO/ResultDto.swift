import Foundation

struct ResultDto: Identifiable, Codable {
    let id: String?
    let testId: String
    let totalGrade: Int
}
