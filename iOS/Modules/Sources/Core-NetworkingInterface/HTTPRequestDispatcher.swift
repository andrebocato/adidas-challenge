import Foundation
import Combine

public protocol HTTPRequestDispatcherProtocol {
    func dataPublisher(for request: HTTPRequestProtocol) -> AnyPublisher<Data, HTTPRequestError>
}

// MARK: - Mappers

extension Publisher where Output == Data {
    // @TODO: write documentation
    public func mapJSONValue<Value>(
        type: Value.Type,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Value, HTTPRequestError> where Value: Decodable {
        decode(type: type, decoder: decoder)
            .mapError {
                switch $0 {
                case let requestError as HTTPRequestError:
                    return requestError
                default:
                    return HTTPRequestError.jsonDecoding($0)
                }
            }
            .eraseToAnyPublisher()
    }
}
