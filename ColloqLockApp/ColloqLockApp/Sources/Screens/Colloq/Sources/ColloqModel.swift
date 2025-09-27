import UIKit

enum ColloqQuestionType {
    case open
    case pick2
    case pick4
}

enum ColloqAnswerModel {
    case open(String)
    case pick2(Int?)
    case pick4(Set<Int>)
}

struct ColloqQuestionModel: Identifiable {
    let id = UUID()
    let type: ColloqQuestionType
    let text: String
    let options: [String]?
    var isAnswered: Bool = false
}
