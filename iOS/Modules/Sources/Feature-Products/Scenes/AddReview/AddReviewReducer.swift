import Combine
import ComposableArchitecture
import Core_RepositoryInterface

typealias AddReviewReducer = Reducer<AddReviewState, AddReviewAction, AddReviewEnvironment>

let addReviewReducer = AddReviewReducer { state, action, environment in
    switch action {
    case .onAppear:
        return .none
        
    case let .updateRating(rating):
        state.rating = rating
        return .none
        
    case let .updateReviewText(text):
        state.reviewText = text
        return .none
        
    case .sendReview:
        state.isLoading = true
        
        let locale = environment.locale() ?? "en-US"
        let review: Review = .init(
            productId: state.productId,
            locale: locale,
            rating: state.rating + 1, // Received value is an index (0-based), hence the +1
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
            environment.onSendReviewSuccess(state.newReview)
        }
        
    case let .handleSendReview(.failure(error)):
        state.isLoading = false
        state.errorAlert = .init(
            title: TextState(L10n.AddReview.Error.title),
            dismissButton: .default(
                TextState(L10n.AddReview.Error.buttonTitle),
                send: .onAppear
            )
        )
        return .none
    }
}
