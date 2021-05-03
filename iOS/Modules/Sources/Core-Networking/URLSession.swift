import Combine
import Foundation

public protocol URLSessionProtocol {
    func anyDataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error>
}
extension URLSession: URLSessionProtocol {
    public func anyDataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error> {
        dataTaskPublisher(for: request)
            .tryMap { ($0.data, $0.response) }
            .eraseToAnyPublisher()
    }
}

#if DEBUG
public final class URLSessionStub: URLSessionProtocol {
    public init() { }
    
    public var resultToBeReturned: Result<(Data, URLResponse), Error> = .success((Data(), URLResponse()))
    
    public func anyDataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error> {
        resultToBeReturned.publisher.eraseToAnyPublisher()
    }
}

public struct URLSessionDummy: URLSessionProtocol {
    public init() { }
    
    public func anyDataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error> {
        Empty().eraseToAnyPublisher()
    }
}
#endif
