import Foundation
import FirebaseFirestore

protocol ProfileInteractor {
    func loadProfile() async throws -> UserProfile?
    func loadColloqs() async throws -> [Colloq]
    func signOut() throws
}

struct UserProfile {
    let displayName: String
    let role: UserRole
}

final class ProfileInteractorImpl: ProfileInteractor {
    
    // MARK: - Init

    init(authService: AuthService) {
        self.authService = authService
    }
    
    // MARK: - Public Methods

    func loadProfile() async throws -> UserProfile? {
        guard let currentUser = authService.currentUser else {
            return nil
        }
        
        let result = try await firestore.collection(FirestoreCollections.users).document(currentUser.uid).getDocument()
        return try toUserProfile(result.data(as: UserDto.self))
    }

    func loadColloqs() async throws -> [Colloq] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return [
            Colloq(name: "Swift Concurrency", date: "13.01.2005"),
            Colloq(name: "Firebase Basics", date: "20.03.2006"),
            Colloq(name: "SwiftUI Advanced", date: "01.04.2007"),
            Colloq(name: "Swift Concurrency", date: "13.01.2005"),
            Colloq(name: "Firebase Basics", date: "20.03.2006"),
            Colloq(name: "SwiftUI Advanced", date: "01.04.2007"),
            Colloq(name: "Swift Concurrency", date: "13.01.2005"),
            Colloq(name: "Firebase Basics", date: "20.03.2006"),
            Colloq(name: "SwiftUI Advanced", date: "01.04.2007"),
            Colloq(name: "Swift Concurrency", date: "13.01.2005"),
            Colloq(name: "Firebase Basics", date: "20.03.2006"),
            Colloq(name: "SwiftUI Advanced", date: "01.04.2007"),
        ]
    }
    
    func signOut() throws {
        try authService.signOut()
    }
    
    // MARK: - Private Properties
    
    private let firestore = Firestore.firestore()
    private let authService: AuthService
    
    // MARK: - Private Methods
    
    private func toUserProfile(_ userDto: UserDto) -> UserProfile {
        UserProfile(displayName: userDto.displayName ?? "Аноним", role: toUserRole(userDto.role))
    }
    
    private func toUserRole(_ role: Role) -> UserRole {
        switch role {
        case .student: .student
        case .teacher: .teacher
        }
    }
}
