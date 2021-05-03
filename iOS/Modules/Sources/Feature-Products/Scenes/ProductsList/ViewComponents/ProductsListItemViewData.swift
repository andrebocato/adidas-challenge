import Core_RepositoryInterface
import Foundation

extension ProductListItemView {
    public struct ViewData: Equatable {
        let imageURL: URL
        let name: String
        let description: String
        let formattedPrice: String
        
        public init(
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
