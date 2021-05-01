import Foundation

/// Represents an error thrown by an HTTPRequest
public enum HTTPRequestError: Error, Equatable {
    /// Represents a serialization error when trying to encode de request data.
    case requestSerialization(Error)
    /// Represents some request error, related to the request.
    case networking(Error)
    /// Reffers to when the HTTP response has invalid format.
    case invalidHTTPResponse
    /// Defines that the error was due to network reachability.
    case unreachableNetwork
    /// Represents an error that contains data, with it's status code.
    case yielding(data: Data, statusCode: Int)
    /// Represents an error that occured when decoding the response data.
    case jsonDecoding(Error)
    
    public static func == (lhs: HTTPRequestError, rhs: HTTPRequestError) -> Bool {
        switch (lhs, rhs) {
        case let (.requestSerialization(e1), .requestSerialization(e2)):
            return e1 as NSError == e2 as NSError
        case let (.networking(e1), .networking(e2)):
            return e1 as NSError == e2 as NSError
        case (.invalidHTTPResponse, .invalidHTTPResponse):
            return true
        case (.unreachableNetwork, .unreachableNetwork):
            return true
        case let (.yielding(d1, c1), .yielding(d2, c2)):
            return d1 == d2 && c1 == c2
        case let (.jsonDecoding(e1), .jsonDecoding(e2)):
            return e1 as NSError == e2 as NSError
        default:
            return false
        }
    }
}
