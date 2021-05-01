import Combine

public protocol ProductRepositoryProtocol {
    func fetchProductsList() -> AnyPublisher<[Product], Error>
}
