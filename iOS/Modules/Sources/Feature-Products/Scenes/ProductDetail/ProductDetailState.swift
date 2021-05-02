import Core_RepositoryInterface
import Foundation

struct ProductDetailState: Equatable {
    let productId: String
    let productName: String
    
    var product: Product? = nil
    var reviews: [ReviewViewData] = []
    var isPresentingAddReviewSheet: Bool = false
    var scene: Scene = .loadingProduct
}

extension ProductDetailState {
    struct ProductViewData: Equatable {
        let productImageURL: URL
        let productName: String
        let productPrice: String
        let productDescription: String
        
        init(from vo: Product) {
            productImageURL = URL(string: vo.imageURL)!
            productName = vo.name
            productPrice = String(vo.price)
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
            locale = vo.locale
        }
    }
    
    enum Scene: Equatable {
        case loadingProduct
        case loadedProduct(ProductViewData)
        case errorFetchingProduct(message: String)
    }
}
