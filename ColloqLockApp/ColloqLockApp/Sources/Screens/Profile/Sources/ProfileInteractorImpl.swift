import Foundation
import FirebaseFirestore

protocol ProfileInteractor {
    func loadProfile() async throws -> UserProfileData
    func loadColloqs() async throws -> [Colloq]
    func changeUserProfile(with displayName: String) async throws
    func signOut() throws
}

struct UserProfileData {
    let displayName: String
    let role: UserRole
}

final class ProfileInteractorImpl: ProfileInteractor {
    
    // MARK: - Init

    init(authService: AuthService) {
        self.authService = authService
    }
    
    // MARK: - Public Methods

    func loadProfile() async throws -> UserProfileData {
        guard let currentUser = authService.currentUser else {
            throw ProfileError.authError
        }
        
        do {
            let result = try await firestore
                .collection(FirestoreCollections.users)
                .document(currentUser.uid)
                .getDocument()
            return try toUserProfile(result.data(as: UserDto.self))
        } catch {
            throw ProfileError.unknown
        }
    }

    func loadColloqs() async throws -> [Colloq] {
        guard let currentUser = authService.currentUser else {
            throw ProfileError.authError
        }
        
        let snapshot = try await firestore
            .collection(FirestoreCollections.userTests)
            .whereField("userId", isEqualTo: currentUser.uid)
            .getDocuments()
        
        var colloqs: [Colloq] = []
        for doc in snapshot.documents {
            guard let testId = doc.data()["testId"] as? String else { continue }
            
            let testDoc = try await firestore
                .collection(FirestoreCollections.tests)
                .document(testId)
                .getDocument()
            
            if let data = testDoc.data() {
                let name = data["title"] as? String ?? ProfileStrings.colloqNamePlaceholder
                let startTime = (data["startTime"] as? Timestamp)?.dateValue()
                
                let dateString: String
                if let date = startTime {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    dateString = formatter.string(from: date)
                } else {
                    dateString = ProfileStrings.colloqDatePlaceholder
                }
                
                colloqs.append(Colloq(name: name, date: dateString))
            }
        }
        
        return colloqs
    }
    
    func changeUserProfile(with displayName: String) async throws {
        guard let currentUser = authService.currentUser else {
            throw ProfileError.authError
        }
        
        do {
            try await firestore
                .collection(FirestoreCollections.users)
                .document(currentUser.uid)
                .updateData([
                    "displayName": displayName
                ])
        } catch {
            throw ProfileError.unknown
        }
    }
    
    func signOut() throws {
        do {
            try authService.signOut()
        } catch {
            throw ProfileError.unknown
        }
    }
    
    // MARK: - Private Properties
    
    private let firestore = Firestore.firestore()
    private let authService: AuthService
    
    // MARK: - Private Methods
    
    private func toUserProfile(_ userDto: UserDto) -> UserProfileData {
        UserProfileData(
            displayName: userDto.displayName ?? ProfileStrings.username,
            role: toUserRole(userDto.role)
        )
    }
    
    private func toUserRole(_ role: Role) -> UserRole {
        switch role {
        case .student: .student
        case .teacher: .teacher
        }
    }
}
