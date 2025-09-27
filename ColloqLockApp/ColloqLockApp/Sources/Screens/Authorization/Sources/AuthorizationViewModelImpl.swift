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
        signInAnonimouslyTask?.cancel()
        
        signInAnonimouslyTask = Task {
            do {
                let user = try await interactor.signInAnonymously()
                try interactor.saveUserData(SaveUserModel(user: user, userRole: userRole))
            } catch let error as AuthorizationError {
                print(error)
            } catch {
                print(error)
            }
        }
    }
    
    private func signUpWithMail() {
        signUpWithMailTask?.cancel()
        
        signUpWithMailTask = Task {
            do {
                let user = try await interactor.signUpWithMail(MailSignModel(
                    email: email,
                    password: password
                ))
                try interactor.saveUserData(SaveUserModel(user: user, userRole: userRole))
            } catch let error as AuthorizationError {
                print(error)
            } catch {
                print(error)
            }
        }
    }
    
    private func signInWithMail() {
        signInWithMailTask?.cancel()
        
        signInWithMailTask = Task {
            do {
                try await interactor.signInWithMail(MailSignModel(
                    email: email,
                    password: password
                ))
            } catch let error as AuthorizationError {
                print(error)
            } catch {
                print(error)
            }
        }
    }
    
    private func signInWithGoogle() {
        signInWithGoogleTask?.cancel()
        
        signInWithGoogleTask = Task {
            do {
                let user = try await interactor.signInWithGoogle()
                try interactor.saveUserData(SaveUserModel(user: user, userRole: userRole))
            } catch let error as AuthorizationError {
                print(error)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let interactor: AuthorizationInteractor
    
    private var signInAnonimouslyTask: Task<Void, Never>?
    private var signUpWithMailTask: Task<Void, Never>?
    private var signInWithMailTask: Task<Void, Never>?
    private var signInWithGoogleTask: Task<Void, Never>?
}
