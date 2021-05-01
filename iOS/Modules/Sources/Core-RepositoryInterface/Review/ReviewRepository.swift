import Combine

public protocol ReviewRepositoryProtocol {
    func sendReview(_ review: Review) -> AnyPublisher<Void, Error>
}
