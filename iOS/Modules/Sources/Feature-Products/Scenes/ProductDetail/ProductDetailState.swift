import Core_RepositoryInterface
import Foundation

struct ProductDetailState: Equatable {
    let productId: String
    var viewData: ViewData
    var isPresentingAddReviewSheet: Bool = false
}

extension ProductDetailState {
    struct ViewData: Equatable {
        let productImageURL: URL
        let productName: String
        let productPrice: String
        let productDescription: String
        var reviews: [ProductReview]
        
        init(from vo: Product) {
            productImageURL = URL(string: vo.imageURL)!
            productName = vo.name
            productPrice = String(vo.price)
            productDescription = vo.description
            reviews = vo.reviews.map { .init(from: $0) }
        }
    }
    
    struct ProductReview: Equatable, Identifiable {
        let id = UUID()
        let rating: Int
        let text: String
        let locale: String
        
        init(from vo: Review) {
            rating = vo.rating
            text = vo.text
            locale = vo.locale
        }
    }
}
