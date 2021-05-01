import Combine
import Core_NetworkingInterface
import Core_RepositoryInterface
import Foundation

public final class ReviewRepository: ReviewRepositoryProtocol {
    
    // MARK: - Dependencies
    
    private let dispatcher: HTTPRequestDispatcherProtocol
    
    // MARK: - Initializers
    
    public init(
        dispatcher: HTTPRequestDispatcherProtocol
    ) {
        self.dispatcher = dispatcher
    }
    
    // MARK: - Request
    
    public func sendReview(_ review: Review) -> AnyPublisher<Void, Error> {
        let reviewDTO: ReviewDTO = .init(
            productId: review.productId,
            locale: review.locale,
            rating: review.rating,
            text: review.text
        )
        let request: ReviewHTTPRequest = .sendReview(reviewDTO)
        
        return dispatcher
            .dataPublisher(for: request)
            .tryMap { _ in () }
            .eraseToAnyPublisher()
    }
}
