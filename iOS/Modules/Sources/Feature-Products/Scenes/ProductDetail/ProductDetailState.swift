import ComposableArchitecture
import Core_RepositoryInterface
import Foundation

struct ProductDetailState: Equatable {
    let productId: String
    let productName: String
    
    var product: Product? = nil
    var reviews: [ReviewViewData] = []
    var isPresentingAddReviewSheet: Bool = false
    var isReloadingReviews: Bool = false
    var scene: Scene = .loadingProduct
    var errorAlert: AlertState<ProductDetailAction>?
}

extension ProductDetailState {
    var shouldFetchProduct: Bool {
        switch scene {
        case .errorFetchingProduct, .loadedProduct:
            return false
        default:
            return product == nil
        }
    }
}

extension ProductDetailState {
    struct ProductViewData: Equatable {
        let productImageURL: URL
        let productName: String
        let formattedPrice: String
        let productDescription: String
        
        init(
            from vo: Product,
            formattedPrice: String
        ) {
            productImageURL = URL(string: vo.imageURL)!
            productName = vo.name
            self.formattedPrice = formattedPrice
            productDescription = vo.description
        }
    }
    
    struct ReviewViewData: Equatable, Identifiable {
        let id: String
        let rating: Int
        let text: String
        let locale: String
        
        init(
            from vo: Review,
            id: String
        ) {
            self.id = id
            rating = vo.rating
            text = vo.text
            locale = vo.locale ?? "nl-NL"
        }
        
        func hasSameData(
            as other: ReviewViewData
        ) -> Bool {
            return rating == other.rating
                && text == other.text
                && locale == other.locale
        }
    }
    
    enum Scene: Equatable {
        case loadingProduct
        case loadedProduct(ProductViewData)
        case errorFetchingProduct(message: String)
    }
}

#if DEBUG
extension ProductDetailState.ReviewViewData {
    static func fixture(
        from vo: Review = .fixture(),
        id: String = ""
    ) -> Self {
        .init(
            from: vo,
            id: id
        )
    }
}
#endif
