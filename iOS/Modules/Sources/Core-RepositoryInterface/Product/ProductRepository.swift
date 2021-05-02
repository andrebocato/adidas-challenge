import Combine

public protocol ProductRepositoryProtocol {
    func fetchProductsList() -> AnyPublisher<[Product], Error>
}

#if DEBUG
public struct ProductRepositoryDummy: ProductRepositoryProtocol {
    public init() { }
    public func fetchProductsList() -> AnyPublisher<[Product], Error> {
        Empty().eraseToAnyPublisher()
    }
}

public final class ProductRepositoryStub: ProductRepositoryProtocol {
    public init() { }
    
    public var fetchProductListResultToBeReturned: Result<[Product], Error> = .success([])
    
    public func fetchProductsList() -> AnyPublisher<[Product], Error> {
        fetchProductListResultToBeReturned.publisher.eraseToAnyPublisher()
    }
}
#endif
