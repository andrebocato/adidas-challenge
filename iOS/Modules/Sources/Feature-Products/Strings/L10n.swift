import Foundation

// @TODO: use a code generation strategy
enum L10n {
    enum ProductsList {
        enum Titles {
            static let products: String = "Products"
            static let tryAgain: String = "Try again"
        }
        enum Error {
            static let title: String = "Something went wrong..."
            static let subtitle: String = "The products couldn't be fetched :("
        }
    }
    enum ProductDetail {
        enum Titles {
            static let addReviewButton: String = "Add review"
            static let tryAgain: String = "Try again"
            static let ok: String = "OK"
        }
        enum Error {
            static let title: String = "Something went wrong..."
            static let networkingMessage: String = "An error occured on our side"
            static let unexpectedMessage: String = "Something unexpected happened"
            static let reloadReviewsMessage: String = "Could not reload reviews"
        }
    }
    enum AddReview {
        enum Titles {
            static let rating: String = "How would you rate this product?"
            static let textReview: String = "Describe your experience with it!"
            static let sendButton: String = "Send Review"
        }
        enum Error {
            static let networkingMessage: String = "Your review could not be sent."
            static let noRatingMessage: String = "You cannot send a review without a rating!"
            static let noTextMessage: String = "You cannot send a review without a text!"
            static let buttonTitle: String = "OK"
        }
    }
}
