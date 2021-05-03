import Combine
import ComposableArchitecture

typealias ProductDetailReducer = Reducer<ProductDetailState, ProductDetailAction, ProductDetailEnvironment>

let productDetailReducer = ProductDetailReducer { state, action, environment in
    switch action {
    case .fetchProduct:
        guard state.shouldFetchProduct else { return .none }
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
            value: .displayError(
                mode: .fullscreen,
                message: L10n.ProductDetail.Error.networkingMessage
            )
        )
        
    case .populateView:
        guard let product = state.product else {
            return .init(
                value: .displayError(
                    mode: .fullscreen,
                    message: L10n.ProductDetail.Error.unexpectedMessage
                )
            )
        }
        
        state.reviews = product.reviews.map {
            .init(
                from: $0,
                id: environment.generateUUIDString()
            )
        }
        
        let productViewData: ProductDetailState.ProductViewData = .init(
            from: product,
            formattedPrice: environment.currencyFormatter.format(product.price)
        )
        state.scene = .loadedProduct(productViewData)
        return .none
        
    case let .displayError(displayMode, message):
        switch displayMode {
        case .alert:
            state.errorAlert = .init(
                title: TextState(message),
                dismissButton: .default(
                    TextState(L10n.ProductDetail.Titles.ok)
                )
            )
        case .fullscreen:
            state.scene = .errorFetchingProduct(message: message)
        }
        return .none
        
    case .presentAddReviewSheet:
        state.isPresentingAddReviewSheet = true
        return .none
        
    case .dismissAddReviewSheet:
        state.isPresentingAddReviewSheet = false
        return .init(value: .fetchReviews)
        
    case .fetchReviews:
        state.isReloadingReviews = true
        return environment
            .reviewRepository
            .getReviews(for: state.productId)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(ProductDetailAction.handleFetchReviews)
        
    case let .handleFetchReviews(.success(response)):
        state.isReloadingReviews = false
        
        var currentReviews = state.reviews
        let updatedReviews: [ProductDetailState.ReviewViewData] = response.map {
            .init(
                from: $0,
                id: environment.generateUUIDString()
            )
        }
        updatedReviews.forEach { newReview in
            if !currentReviews.contains(where: { $0.hasSameData(as: newReview) } ) {
                currentReviews.append(newReview)
            }
        }
        
        state.reviews = currentReviews
        return .none
        
    case let .handleFetchReviews(.failure(error)):
        state.isReloadingReviews = false
        return .init(
            value: .displayError(
                mode: .alert,
                message: L10n.ProductDetail.Error.reloadReviewsMessage
            )
        )
        
    case .dismissErrorAlert:
        state.errorAlert = nil
        return .none
    }
}
