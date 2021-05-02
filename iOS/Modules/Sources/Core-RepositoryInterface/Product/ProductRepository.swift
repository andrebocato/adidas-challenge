import Combine

public protocol ProductRepositoryProtocol {
    func fetchProductsList() -> AnyPublisher<[Product], Error>
    func fetchProduct(withID id: String) -> AnyPublisher<Product, Error>
}

#if DEBUG
public struct ProductRepositoryDummy: ProductRepositoryProtocol {
    public init() { }
    public func fetchProductsList() -> AnyPublisher<[Product], Error> {
        Empty().eraseToAnyPublisher()
    }
    
    public func fetchProduct(withID id: String) -> AnyPublisher<Product, Error> {
        Empty().eraseToAnyPublisher()
    }
}

public final class ProductRepositoryStub: ProductRepositoryProtocol {
    public init() { }
    
    public var fetchProductListResultToBeReturned: Result<[Product], Error> = .success([])
    public func fetchProductsList() -> AnyPublisher<[Product], Error> {
        fetchProductListResultToBeReturned.publisher.eraseToAnyPublisher()
    }
    
    public var fetchProductWithIDResultToBeReturned: Result<Product, Error> = .success(.fixture())
    public func fetchProduct(withID id: String) -> AnyPublisher<Product, Error> {
        fetchProductWithIDResultToBeReturned.publisher.eraseToAnyPublisher()
    }
}
#endif
