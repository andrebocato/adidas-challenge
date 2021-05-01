import Combine
import ComposableArchitecture

typealias ProductDetailReducer = Reducer<ProductDetailState, ProductDetailAction, ProductDetailEnvironment>

let productDetailReducer = ProductDetailReducer { state, action, environment in
    switch action {
    case .onAppear:
        return .none
    case let .presentingAddReviewSheet(isPresenting):
        state.isPresentingAddReviewSheet = isPresenting
        return .none
    }
}
