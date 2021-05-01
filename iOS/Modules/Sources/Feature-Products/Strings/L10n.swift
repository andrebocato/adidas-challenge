import Foundation

// @TODO: use a code generation strategy
enum L10n {
    enum ProductsList {
        enum Titles {
            static let products: String = "Products"
        }
        enum Error {
            static let title: String = "Something went wrong..."
            static let subtitle: String = "The products couldn't be fetched :("
            static let tryAgain: String = "Try again"
        }
    }
    enum ProductDetail {
        enum Titles {
            static let addReviewButton: String = "Add review"
        }
    }
}
