import Foundation

enum AddReviewAction {
    case updateRating(Int)
    case updateReviewText(String)
    case sendReview
    case handleSendReview(Result<Void, Error>)
    case showErrorAlert(message: String)
    case dismissErrorAlert
}

extension AddReviewAction: Equatable {
    static func == (lhs: AddReviewAction, rhs: AddReviewAction) -> Bool {
        switch (lhs, rhs) {
        case (.sendReview, .sendReview), (.dismissErrorAlert, .dismissErrorAlert):
            return true
        case let (.updateRating(r1), .updateRating(r2)):
            return r1 == r2
        case let (.updateReviewText(t1), .updateReviewText(t2)):
            return t1 == t2
        case let (.showErrorAlert(m1), .showErrorAlert(m2)):
            return m1 == m2
        case (.handleSendReview(.success), .handleSendReview(.success)):
            return true
        case let (.handleSendReview(.failure(e1)), .handleSendReview(.failure(e2))):
            return e1 as NSError == e2 as NSError
        default:
            return false
        }
    }
}
