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
