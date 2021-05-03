import Core_RepositoryInterface
import Foundation

extension ProductListItemView {
    struct ViewData: Equatable {
        let imageURL: URL
        let name: String
        let description: String
        let formattedPrice: String
        
        init(
            from vo: Product,
            formattedPrice: String
        ) {
            imageURL = URL(string: vo.imageURL)!
            name = vo.name
            description = vo.description
            self.formattedPrice = formattedPrice
        }
    }
}
