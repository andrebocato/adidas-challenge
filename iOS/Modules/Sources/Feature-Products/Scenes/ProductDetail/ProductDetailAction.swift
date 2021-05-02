import Core_RepositoryInterface
import Foundation

enum ProductDetailAction {
    case fetchProduct
    case handleFetchProduct(Result<Product, Error>)
    case populateView
    case displayError(message: String)
    case presentAddReviewSheet
    case dismissAddReviewSheet(newReview: Review? = nil)
}

extension ProductDetailAction: Equatable {
    static func == (lhs: ProductDetailAction, rhs: ProductDetailAction) -> Bool {
        switch (lhs, rhs) {
        case (.fetchProduct, .fetchProduct), (.populateView, .populateView), (.presentAddReviewSheet, .presentAddReviewSheet):
            return true
        case let (.displayError(m1), .displayError(m2)):
            return m1 == m2
        case let (.dismissAddReviewSheet(r1), .dismissAddReviewSheet(r2)):
            return r1 == r2
        case let (.handleFetchProduct(.success(r1)), .handleFetchProduct(.success(r2))):
            return r1 == r2
        case let (.handleFetchProduct(.failure(e1)), .handleFetchProduct(.failure(e2))):
            return e1 as NSError == e2 as NSError
        default:
            return false
        }
    }
}
