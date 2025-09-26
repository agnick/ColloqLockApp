import Foundation

struct UserDto: Identifiable, Codable {
    let id: String
    let email: String?
    let displayName: String?
    let role: Role
}

enum Role: String, Codable {
    case teacher
    case student
}
