import Core_RepositoryInterface
import Foundation

enum ProductDetailAction {
    case fetchProduct
    case handleFetchProduct(Result<Product, Error>)
    case populateView
    case displayError(mode: ErrorDisplayMode, message: String)
    case dismissErrorAlert
    case presentAddReviewSheet
    case dismissAddReviewSheet
    case fetchReviews
    case handleFetchReviews(Result<[Review], Error>)
}

extension ProductDetailAction {
    enum ErrorDisplayMode: Equatable {
        case fullscreen
        case alert
    }
}

extension ProductDetailAction: Equatable {
    static func == (lhs: ProductDetailAction, rhs: ProductDetailAction) -> Bool {
        switch (lhs, rhs) {
        case (.fetchProduct, .fetchProduct),
             (.populateView, .populateView),
             (.dismissErrorAlert, .dismissErrorAlert),
             (.presentAddReviewSheet, .presentAddReviewSheet),
             (.dismissAddReviewSheet, .dismissAddReviewSheet),
             (.fetchReviews, .fetchReviews):
            return true
        case let (.displayError(mode1, msg1), .displayError(mode2, msg2)):
            return mode1 == mode2 && msg1 == msg2
        case let (.handleFetchProduct(.success(r1)), .handleFetchProduct(.success(r2))):
            return r1 == r2
        case let (.handleFetchProduct(.failure(e1)), .handleFetchProduct(.failure(e2))):
            return e1 as NSError == e2 as NSError
        case let (.handleFetchReviews(.success(r1)), .handleFetchReviews(.success(r2))):
            return r1 == r2
        case let (.handleFetchReviews(.failure(e1)), .handleFetchReviews(.failure(e2))):
            return e1 as NSError == e2 as NSError
        default:
            return false
        }
    }
}
