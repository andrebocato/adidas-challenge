import Core_NetworkingInterface
import Foundation

enum ProductHTTPRequest {
    case fetchAll
    case fetchProduct(id: String)
}

extension ProductHTTPRequest: HTTPRequestProtocol {
    var baseURL: URL { URL(string: "http://localhost:3001")! }
    
    var path: String {
        switch self {
        case .fetchAll:
            return "/product"
        case let .fetchProduct(id):
            return "/product/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchAll, .fetchProduct:
            return .get
        }
    }
}
