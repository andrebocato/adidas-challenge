import Combine
import ComposableArchitecture

typealias ProductDetailReducer = Reducer<ProductDetailState, ProductDetailAction, ProductDetailEnvironment>

let productDetailReducer = ProductDetailReducer { state, action, environment in
    switch action {
    case .onAppear:
        state.reviewsViewData = state.product.reviews.map {
            .init(
                from: $0,
                id: environment.generateUUIDString()
            )
        }
        return .none
        
    case .presentAddReviewSheet:
        state.isPresentingAddReviewSheet = true
        return .none
        
    case let .dismissAddReviewSheet(newReview):
        state.isPresentingAddReviewSheet = false
        if let newReview = newReview {
            state.reviewsViewData.append(
                .init(
                    from: newReview,
                    id: environment.generateUUIDString()
                )
            )
        }
        return .none
    }
}

// Note:
// I've chosen to pass the newly created review as a parameter from the AddReviewView
// because i've had so many problems to get the reviews list from the request.
