import Combine

public protocol ReviewRepositoryProtocol {
    func sendReview(_ review: Review) -> AnyPublisher<Void, Error>
    func getReviews(for productID: String) -> AnyPublisher<[Review], Error>
}

#if DEBUG
public struct ReviewRepositoryDummy: ReviewRepositoryProtocol {
    public init() { }
    
    public func sendReview(_ review: Review) -> AnyPublisher<Void, Error> {
        Empty().eraseToAnyPublisher()
    }
    
    public func getReviews(for productID: String) -> AnyPublisher<[Review], Error> {
        Empty().eraseToAnyPublisher()
    }
}

public final class ReviewRepositoryStub: ReviewRepositoryProtocol {
    public init() { }
    
    public var sendReviewResultToBeReturned: Result<Void, Error> = .success(())
    public func sendReview(_ review: Review) -> AnyPublisher<Void, Error> {
        sendReviewResultToBeReturned.publisher.eraseToAnyPublisher()
    }
    
    public var getReviewsResultToBeReturned: Result<[Review], Error> = .success([])
    public func getReviews(for productID: String) -> AnyPublisher<[Review], Error> {
        getReviewsResultToBeReturned.publisher.eraseToAnyPublisher()
    }
}
#endif
