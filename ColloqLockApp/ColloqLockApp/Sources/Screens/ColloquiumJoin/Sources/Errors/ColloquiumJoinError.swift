import Foundation
import FirebaseFirestore

enum ColloquiumJoinError: Error {
    case invalidCode
    case codeNotFound
    case colloquiumEnded
    case colloquiumNotStarted
    case accessDenied
    case networkError
    case unknown
    
    var title: String {
        switch self {
        case .invalidCode: "Некорректный код"
        case .codeNotFound: "Коллоквиум не найден"
        case .colloquiumEnded: "Коллоквиум уже завершен"
        case .colloquiumNotStarted: "Коллоквиум еще не начался"
        case .accessDenied: "Доступ запрещен"
        case .networkError: "Ошибка сети"
        case .unknown: "Произошла непредвиденная ошибка"
        }
    }
}
