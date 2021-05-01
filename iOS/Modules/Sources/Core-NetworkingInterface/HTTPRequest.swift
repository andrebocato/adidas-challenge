import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum HTTPRequestParameters {
    case body([String: Any])
    case urlQuery([String: String])
    case bodyData(Data)
    case requestPlain
}

public protocol HTTPRequestProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: HTTPRequestParameters { get }
    var headers: [String: String]? { get }
}

public extension HTTPRequestProtocol {
    var parameters: HTTPRequestParameters { .requestPlain }
    var headers: [String: String]? { nil }
}
