import Core_RepositoryInterface
import Foundation

extension ProductListItemView {
    struct ViewData {
        let imageURL: URL
        let name: String
        let description: String
        let price: String
        
        init(from vo: Product) {
            imageURL = URL(string: vo.imageURL)!
            name = vo.name
            description = vo.description
            price = String(vo.price) // @TODO: change this
        }
    }
}
