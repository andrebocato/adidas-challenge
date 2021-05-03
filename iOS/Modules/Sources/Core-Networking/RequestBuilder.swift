import Foundation
import Core_NetworkingInterface

protocol RequestBuilderProtocol {
    func build(from request: HTTPRequestProtocol) throws -> URLRequest
}

final class DefaultRequestBuilder: RequestBuilderProtocol {
    
    // MARK: - Dependencies

    private let jsonSerializer: JSONSerialization.Type

    // MARK: - Initializers
    
    init(jsonSerializer: JSONSerialization.Type = JSONSerialization.self) {
        self.jsonSerializer = jsonSerializer
    }

    func build(from request: HTTPRequestProtocol) throws -> URLRequest {
        var endpointURL = request.baseURL
        if !request.path.isEmpty {
            endpointURL = endpointURL.appendingPathComponent(request.path)
        }

        var urlRequest: URLRequest = .init(url: endpointURL)
        urlRequest.httpMethod = request.method.rawValue

        request.headers?.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        switch request.parameters {
        case let .body(parameters):
            urlRequest.httpBody = try jsonSerializer.data(withJSONObject: parameters, options: .fragmentsAllowed)

        case let .urlQuery(parameters):
            guard var urlComponents = URLComponents(url: endpointURL, resolvingAgainstBaseURL: true) else {
                return urlRequest
            }
            urlComponents.queryItems = parameters.map { .init(name: $0.key, value: $0.value) }
            urlRequest.url = urlComponents.url

        case let .bodyData(data):
            urlRequest.httpBody = data

        case .requestPlain:
            break
        }

        return urlRequest
    }
}

#if DEBUG
// MARK: - Test Doubles

struct RequestBuilderDummy: RequestBuilderProtocol {
    init() { }
    
    func build(from request: HTTPRequestProtocol) throws -> URLRequest {
        .init(url: .dummy())
    }
}

final class RequestBuilderStub: RequestBuilderProtocol {
    init() { }

    var buildResultToBeReturned: Result<URLRequest, Error> = .success(.init(url: .dummy()))
    
    func build(from request: HTTPRequestProtocol) throws -> URLRequest {
        switch buildResultToBeReturned {
        case let .success(urlRequest):
            return urlRequest
        case let .failure(error):
            throw error
        }
    }
}
#endif