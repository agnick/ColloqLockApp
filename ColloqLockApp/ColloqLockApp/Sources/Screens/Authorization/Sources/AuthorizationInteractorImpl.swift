import Foundation
import FirebaseAuth
import Firebase
import GoogleSignIn

protocol AuthorizationInteractor {
    func signUpWithMail(_ model: MailSignModel) async throws -> User
    func signInWithMail(_ model: MailSignModel) async throws
    func signInWithGoogle() async throws -> User
    func signInAnonymously() async throws -> User
    func saveUserData(_ model: SaveUserModel) throws
}

struct SaveUserModel {
    let user: User
    let userRole: UserRole
}

struct MailSignModel {
    let email: String
    let password: String
}

final class AuthorizationInteractorImpl: AuthorizationInteractor {
    
    // MARK: - Public Methods
    
    func signUpWithMail(_ model: MailSignModel) async throws -> User {
        do {
            let result = try await Auth.auth().createUser(withEmail: model.email, password: model.password)
            return result.user
        } catch {
            throw AuthorizationError.from(error)
        }
    }
    
    func signInWithMail(_ model: MailSignModel) async throws {
        do {
            try await Auth.auth().signIn(withEmail: model.email, password: model.password)
        } catch {
            throw AuthorizationError.from(error)
        }
    }
    
    func signInWithGoogle() async throws -> User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthorizationError.unknown
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard
            let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = await scene.windows.first?.rootViewController
        else {
            throw AuthorizationError.unknown
        }

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = result.user
            guard let idToken = user.idToken?.tokenString else {
                throw AuthorizationError.unknown
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            let authResult = try await Auth.auth().signIn(with: credential)
            return authResult.user
        } catch {
            throw AuthorizationError.from(error)
        }
    }
    
    func signInAnonymously() async throws -> User {
        do {
            let result = try await Auth.auth().signInAnonymously()
            return result.user
        } catch {
            throw AuthorizationError.from(error)
        }
    }
        
    func saveUserData(_ model: SaveUserModel) throws {
        let request = UserDto(
            id: model.user.uid,
            email: model.user.email,
            displayName: model.user.displayName,
            role: toRole(model.userRole)
        )
        
        try firestore.collection(FirestoreCollections.users).document(model.user.uid).setData(from: request)
    }
    
    // MARK: - Private Methods
    
    private func toRole(_ userRole: UserRole) -> Role {
        switch userRole {
        case .student: .student
        case .teacher: .teacher
        }
    }
    
    // MARK: - Private Properties
    
    private let firestore = Firestore.firestore()
}
