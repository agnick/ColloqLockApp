import UIKit

struct UserData: Codable {
    let id: String
    let email: String?
    let displayName: String
    let role: String
    
    init(id: String, email: String? = nil, displayName: String = "Аноним", role: String) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.role = role
    }
}

struct Colloq: Identifiable {
    let id = UUID()
    let name: String
    let date: String
}
