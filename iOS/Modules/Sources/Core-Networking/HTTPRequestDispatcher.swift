import Combine
import Foundation
import Core_NetworkingInterface

public final class HTTPRequestDispatcher: HTTPRequestDispatcherProtocol {

    // MARK: - Dependencies

    private let session: URLSessionProtocol
    private let requestBuilder: RequestBuilderProtocol

    // MARK: - Initializer

    init(
        session: URLSessionProtocol,
        requestBuilder: RequestBuilderProtocol
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
    }

    public convenience init() {
        self.init(
            session: URLSession.shared,
            requestBuilder: DefaultRequestBuilder()
        )
    }

    // MARK: - Public API

    public func dataPublisher(for request: HTTPRequestProtocol) -> AnyPublisher<Data, HTTPRequestError> {
        do {
            let urlRequest = try requestBuilder.build(from: request)
            return session
                .anyDataTaskPublisher(for: urlRequest)
                .tryMap { data, response -> Data in
                    guard
                        let httpResponse = response as? HTTPURLResponse
                    else { throw HTTPRequestError.invalidHTTPResponse }

                    guard 200 ... 299 ~= httpResponse.statusCode else {
                        throw HTTPRequestError.yielding(
                            data: data,
                            statusCode: httpResponse.statusCode
                        )
                    }

                    return data
                }
                .mapError { rawError -> HTTPRequestError in
                    if rawError.isNetworkConnectionError {
                        return .unreachableNetwork
                    }

                    switch rawError {
                    case let requestError as HTTPRequestError:
                        return requestError
                    default:
                        return .networking(rawError)
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            let httpError: HTTPRequestError = .requestSerialization(error)
            return Fail(error: httpError).eraseToAnyPublisher()
        }
    }
}
