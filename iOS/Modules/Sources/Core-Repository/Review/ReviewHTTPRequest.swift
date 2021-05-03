import Core_NetworkingInterface
import Foundation

enum ReviewHTTPRequest {
    case sendReview(ReviewDTO)
    case getReviews(productID: String)
}

extension ReviewHTTPRequest: HTTPRequestProtocol {
    var baseURL: URL { URL(string: "http://localhost:3002")! }
    
    var path: String {
        switch self {
        case let .sendReview(review):
            return "/reviews/\(review.productId)"
        case let .getReviews(productId):
            return "/reviews/\(productId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendReview:
            return .post
        case .getReviews:
            return .get
        }
    }
    
    var parameters: HTTPRequestParameters {
        switch self {
        case let .sendReview(review):
            return .body([
                "productId": review.productId,
                "locale": review.locale ?? "",
                "rating": review.rating,
                "text": review.text
            ])
        case .getReviews:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .sendReview, .getReviews:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
}
