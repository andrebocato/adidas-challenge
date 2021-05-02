import Core_RepositoryInterface
import Foundation

struct ProductDetailState: Equatable {
    let product: Product
    let productViewData: ProductViewData
    var reviewsViewData: [ReviewViewData] = []
    var isPresentingAddReviewSheet: Bool = false
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
}
