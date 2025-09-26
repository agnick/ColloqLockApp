import SwiftUI

enum AuthMethod {
    case mail
    case google
    case anonymous
}

enum UserRole {
    case student
    case teacher
}

@MainActor
final class AuthorizationViewModelImpl: AuthorizationViewModel {
    
    // MARK: - Internal Properties
    
    @Published var isSignInMode: Bool = false
    @Published var isAuthFormPresented: Bool = false
    @Published var authMethod: AuthMethod? = nil
    @Published var userRole: UserRole = .student
    
    var email: String = ""
    var password: String = ""
    
    // MARK: - Init
    
    init(interactor: AuthorizationInteractor) {
        self.interactor = interactor
    }
    
    // MARK: - Public Methods
    
    func authorize() {
        switch authMethod {
        case .mail:
            isSignInMode ? signInWithMail() : signUpWithMail()
        case .google:
            signInWithGoogle()
        case .anonymous:
            signInAnonimously()
        default : return
        }
    }
    
    // MARK: - Private Methods
    
    private func signInAnonimously() {
        Task {
            do {
                let user = try await interactor.signInAnonymously()
                try interactor.saveUserData(SaveUserModel(user: user, userRole: userRole))
            } catch let error as AuthorizationError {
                print(error)
            }
        }
    }
    
    private func signUpWithMail() {
        Task {
            do {
                let user = try await interactor.signUpWithMail(MailSignModel(
                    email: email,
                    password: password
                ))
                try interactor.saveUserData(SaveUserModel(user: user, userRole: userRole))
            } catch let error as AuthorizationError {
                print(error)
            }
        }
    }
    
    private func signInWithMail() {
        Task {
            do {
                try await interactor.signInWithMail(MailSignModel(
                    email: email,
                    password: password
                ))
            } catch let error as AuthorizationError {
                print(error)
            }
        }
    }
    
    private func signInWithGoogle() {
        Task {
            do {
                let user = try await interactor.signInWithGoogle()
                try interactor.saveUserData(SaveUserModel(user: user, userRole: userRole))
            } catch let error as AuthorizationError {
                print(error)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let interactor: AuthorizationInteractor
}
