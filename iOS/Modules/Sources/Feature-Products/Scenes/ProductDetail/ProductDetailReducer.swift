import Combine
import ComposableArchitecture

typealias ProductDetailReducer = Reducer<ProductDetailState, ProductDetailAction, ProductDetailEnvironment>

let productDetailReducer = ProductDetailReducer { state, action, environment in
    switch action {
    case .onAppear:
        return .none
        
    case .presentAddReviewSheet:
        state.isPresentingAddReviewSheet = true
        return .none
        
    case let .dismissAddReviewSheet(newReview):
        state.isPresentingAddReviewSheet = false
        if let newReview = newReview {
            state.viewData.reviews.append(.init(from: newReview))
        }
        return .none
    }
}

// Note:
// I've chosen to pass the newly created review as a parameter from the AddReviewView
// because i've had so many problems to get the reviews list from the request.
