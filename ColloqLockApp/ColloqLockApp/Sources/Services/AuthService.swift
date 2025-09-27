import FirebaseAuth
import FirebaseFirestore

enum AuthState {
    case signedOut
    case signedIn(User)
}

protocol AuthService {
    var currentUser: User? { get }
    func start(onChange: @escaping (AuthState) -> Void)
    func signOut() throws
    var currentUserID: String? { get }
    
}

final class AuthServiceImpl: AuthService {
    
    // MARK: - Deinit
    
    deinit {
        if let h = authHandle {
            Auth.auth().removeStateDidChangeListener(h)
        }
    }
    
    // MARK: - Internal Properties

    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    // MARK: - Public Methods

    func start(onChange: @escaping (AuthState) -> Void) {
        self.stateChanged = onChange

        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            if let user {
                self.stateChanged?(.signedIn(user))
            } else {
                self.stateChanged?(.signedOut)
            }
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Private Methods
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    private var stateChanged: ((AuthState) -> Void)?
}

extension AuthServiceImpl {
    var currentUserID: String? {
        return currentUser?.uid
    }
}
