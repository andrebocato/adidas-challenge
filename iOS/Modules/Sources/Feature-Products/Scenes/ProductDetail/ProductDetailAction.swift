import Core_RepositoryInterface
import Foundation

enum ProductDetailAction: Equatable {
    case onAppear
    case presentAddReviewSheet
    case dismissAddReviewSheet(newReview: Review? = nil)
}
