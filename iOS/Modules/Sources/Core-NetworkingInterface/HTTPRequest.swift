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

#if DEBUG
// MARK: - Test Doubles

public struct HTTPRequestDummy: HTTPRequestProtocol {
    public init() { }
    
    public var baseURL: URL { .dummy() }
    
    public var path: String { "" }
    
    public var method: HTTPMethod { .get }
}

extension URL {
    public static func dummy() -> Self {
        guard let dummyURL = URL(string: "www.dummy.com") else {
            preconditionFailure("This should have never failed...")
        }
        return dummyURL
    }
}
#endif
