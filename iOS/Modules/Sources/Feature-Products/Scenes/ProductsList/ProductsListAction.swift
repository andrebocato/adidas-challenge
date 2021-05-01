import Core_RepositoryInterface
import Foundation

public enum ProductsListAction {
    case fetchList
    case handleList(Result<[Product], Error>)
    case listProducts
}

extension ProductsListAction: Equatable {
    public static func == (lhs: ProductsListAction, rhs: ProductsListAction) -> Bool {
        switch (lhs, rhs) {
        case (.fetchList, .fetchList), (.listProducts, .listProducts):
            return true
        case let (.handleList(.success(r1)), .handleList(.success(r2))):
            return r1 == r2
        case let (.handleList(.failure(e1)), .handleList(.failure(e2))):
            return e1 as NSError == e2 as NSError
        default:
            return false
        }
    }
}
