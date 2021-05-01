import Core_NetworkingInterface
import Foundation

enum ReviewHTTPRequest {
    case sendReview(ReviewDTO)
}

extension ReviewHTTPRequest: HTTPRequestProtocol {
    var baseURL: URL { URL(string: "http://localhost:3002")! }
    
    var path: String {
        switch self {
        case .sendReview:
            return "/reviews/1"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendReview:
            return .post
        }
    }
    
    var parameters: HTTPRequestParameters {
        switch self {
        case let .sendReview(review):
            return .body([
                "productId": review.productId,
                "locale": review.locale,
                "rating": review.rating,
                "text": review.text
            ])
        }
    }
}
