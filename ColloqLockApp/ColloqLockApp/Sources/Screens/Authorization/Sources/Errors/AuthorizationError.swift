import Foundation
import FirebaseAuth

enum AuthorizationError: CustomStringConvertible, Error {
    
    case invalidEmail
    case emailAlreadyInUse
    case operationNotAllowed
    case weakPassword
    case userDisabled
    case wrongPassword
    case unknown
    
    var description: String {
        switch self {
        case .invalidEmail: "Некорректный email"
        case .emailAlreadyInUse: "Email уже используется"
        case .operationNotAllowed: "Операция недоступна"
        case .weakPassword: "Слишком слабый пароль"
        case .userDisabled: "Аккаунт отключён"
        case .wrongPassword: "Неверный пароль"
        case .unknown: "Произошла непредвиденная ошибка"
        }
    }
}

extension AuthorizationError {
    static func from(_ error: Error) -> AuthorizationError {
        let nsError = error as NSError
        if nsError.domain == AuthErrorDomain, let authError = AuthErrorCode(rawValue: nsError.code) {
            switch authError.code {
            case .invalidEmail: return .invalidEmail
            case .emailAlreadyInUse: return .emailAlreadyInUse
            case .operationNotAllowed: return .operationNotAllowed
            case .weakPassword: return .weakPassword
            case .userDisabled: return .userDisabled
            case .wrongPassword: return .wrongPassword
            default: return .unknown
            }
        }
        
        return .unknown
    }
}
