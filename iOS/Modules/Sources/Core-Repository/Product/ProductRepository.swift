import Combine
import Core_NetworkingInterface
import Core_RepositoryInterface
import Foundation

public final class ProductRepository: ProductRepositoryProtocol {
    
    // MARK: - Dependencies
    
    private let dispatcher: HTTPRequestDispatcherProtocol
    private let decoder: JSONDecoder
    
    // MARK: - Initializers
    
    public init(
        dispatcher: HTTPRequestDispatcherProtocol,
        decoder: JSONDecoder = .init()
    ) {
        self.dispatcher = dispatcher
        self.decoder = decoder
    }

    // MARK: - Request
    
    public func fetchProductsList() -> AnyPublisher<[Product], Error> {
        let request: ProductHTTPRequest = .fetchAll
        return dispatcher
            .dataPublisher(for: request)
            .tryMap { [decoder] data in
                let decodedObjects = try decoder.decode([ProductDTO].self, from: data)
                return decodedObjects.map { .init(from: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchProduct(withID id: String) -> AnyPublisher<Product, Error> {
        let request: ProductHTTPRequest = .fetchProduct(id: id)
        return dispatcher
            .dataPublisher(for: request)
            .tryMap { [decoder] data in
                let decodedObject = try decoder.decode(ProductDTO.self, from: data)
                return .init(from: decodedObject)
            }
            .eraseToAnyPublisher()
    }
}
