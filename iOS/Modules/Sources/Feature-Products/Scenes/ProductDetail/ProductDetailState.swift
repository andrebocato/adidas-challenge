import Core_RepositoryInterface
import Foundation

struct ProductDetailState: Equatable {
    let viewData: ViewData
}

extension ProductDetailState {
    struct ViewData: Equatable {
        let productImageURL: URL
        let productName: String
        let productPrice: String
        let productDescription: String
        let reviews: [ProductReview]
        
        init(from vo: Product) {
            productImageURL = URL(string: vo.imageURL)!
            productName = vo.name
            productPrice = String(vo.price)
            productDescription = vo.description
            reviews = vo.reviews.map { .init(from: $0) }
        }
    }
    
    struct ProductReview: Equatable, Identifiable {
        let id: String
        let rating: Int
        let text: String
        let locale: String
        
        init(from vo: Review) {
            id = vo.productId
            rating = vo.rating
            text = vo.text
            locale = vo.locale
        }
    }
}
