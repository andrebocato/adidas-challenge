import Combine
import ComposableArchitecture
import Core_RepositoryInterface

typealias AddReviewReducer = Reducer<AddReviewState, AddReviewAction, AddReviewEnvironment>

let addReviewReducer = AddReviewReducer { state, action, environment in
    switch action {
    case let .updateRating(rating):
        state.rating = rating
        return .none
        
    case let .updateReviewText(text):
        state.reviewText = text
        return .none
        
    case .sendReview:
        state.isLoading = true
        
        guard let rating = state.rating else {
            return .init(
                value: .showErrorAlert(
                    message: L10n.AddReview.Error.noRatingMessage
                )
            )
        }
        guard !state.reviewText.isEmpty else {
            return .init(
                value: .showErrorAlert(
                    message: L10n.AddReview.Error.noTextMessage
                )
            )
        }
        
        let locale = environment.locale() ?? "nl-NL"
        let review: Review = .init(
            productId: state.productId,
            locale: locale,
            rating: rating + 1, // Received value is an index (0-based), hence the +1
            text: state.reviewText
        )
        state.newReview = review
        
        return environment
            .reviewRepository
            .sendReview(review)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AddReviewAction.handleSendReview)
    
    case .handleSendReview(.success(())):
        state.isLoading = false
        return .fireAndForget { [state] in
            environment.onSendReviewSuccess()
        }
        
    case let .handleSendReview(.failure(error)):
        state.isLoading = false
        return .init(
            value: .showErrorAlert(
                message: L10n.AddReview.Error.networkingMessage
            )
        )
        
    case let .showErrorAlert(message):
        state.errorAlert = .init(
            title: TextState(message),
            dismissButton: .default(
                TextState(L10n.AddReview.Error.buttonTitle)
            )
        )
        return .none
        
    case .dismissErrorAlert:
        state.isLoading = false
        state.errorAlert = nil
        return .none
    }
}
