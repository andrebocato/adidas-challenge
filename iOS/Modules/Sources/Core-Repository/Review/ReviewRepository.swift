import Combine
import Core_NetworkingInterface
import Core_RepositoryInterface
import Foundation

public final class ReviewRepository: ReviewRepositoryProtocol {
    
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
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    public func getReviews(for productID: String) -> AnyPublisher<[Review], Error> {
        let request: ReviewHTTPRequest = .getReviews(productID: productID)
        return dispatcher
            .dataPublisher(for: request)
            .tryMap { [decoder] data in
                let decodedObjects = try decoder.decode([ReviewDTO].self, from: data)
                return decodedObjects.map { .init(from: $0) }
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
