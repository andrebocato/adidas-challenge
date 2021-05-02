import Combine

public protocol ReviewRepositoryProtocol {
    func sendReview(_ review: Review) -> AnyPublisher<Void, Error>
}

#if DEBUG
public struct ReviewRepositoryDummy: ReviewRepositoryProtocol {
    public init() { }
    
    public func sendReview(_ review: Review) -> AnyPublisher<Void, Error> {
        Empty().eraseToAnyPublisher()
    }
}

public final class ReviewRepositoryStub: ReviewRepositoryProtocol {
    public init() { }
    
    public var sendReviewResultToBeReturned: Result<Void, Error> = .success(())
    
    public func sendReview(_ review: Review) -> AnyPublisher<Void, Error> {
        sendReviewResultToBeReturned.publisher.eraseToAnyPublisher()
    }
}
#endif
