import Core_NetworkingInterface
import Foundation

enum ProductHTTPRequest {
    case fetchAll
}

extension ProductHTTPRequest: HTTPRequestProtocol {
    var baseURL: URL { URL(string: "http://localhost:3001")! }
    
    var path: String {
        switch self {
        case .fetchAll:
            return "/product"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchAll:
            return .get
        }
    }
}
