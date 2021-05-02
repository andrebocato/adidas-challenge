import Combine
import ComposableArchitecture

typealias ProductDetailReducer = Reducer<ProductDetailState, ProductDetailAction, ProductDetailEnvironment>

let productDetailReducer = ProductDetailReducer { state, action, environment in
    switch action {
    case .fetchProduct:
        guard state.product == nil else { return .none }
        state.scene = .loadingProduct
        return environment
            .productRepository
            .fetchProduct(withID: state.productId)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(ProductDetailAction.handleFetchProduct)
        
    case let .handleFetchProduct(.success(response)):
        state.product = response
        return .init(value: .populateView)
        
    case let .handleFetchProduct(.failure(error)):
        return .init(
            value: .displayError(message: L10n.ProductDetail.Error.networkingMessage)
        )
        
    case .populateView:
        guard let product = state.product else {
            return .init(
                value: .displayError(message: L10n.ProductDetail.Error.unexpectedMessage)
            )
        }
        
        state.reviews = product.reviews.map {
            .init(
                from: $0,
                id: environment.generateUUIDString()
            )
        }
        
        let productViewData: ProductDetailState.ProductViewData = .init(from: product)
        state.scene = .loadedProduct(productViewData)
        return .none
        
    case let .displayError(message):
        state.scene = .errorFetchingProduct(message: message)
        return .none
        
    case .presentAddReviewSheet:
        state.isPresentingAddReviewSheet = true
        return .none
        
    case let .dismissAddReviewSheet(newReview):
        state.isPresentingAddReviewSheet = false
        if let newReview = newReview {
            state.reviews.append(
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
