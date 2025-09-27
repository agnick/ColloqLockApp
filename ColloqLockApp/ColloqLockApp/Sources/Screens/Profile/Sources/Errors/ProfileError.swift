import Foundation

enum ProfileError: CustomStringConvertible, Error {
    case authError
    case nameIsEmpty
    case unknown
    
    var description: String {
        switch self {
        case .authError: "Ошибка авторизации, повторите позже"
        case .nameIsEmpty: "Имя не может быть пустым"
        case .unknown: "Произошла непредвиденная ошибка"
        }
    }
}
