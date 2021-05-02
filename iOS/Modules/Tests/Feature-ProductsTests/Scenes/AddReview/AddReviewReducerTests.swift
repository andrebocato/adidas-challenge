import Combine
import ComposableArchitecture
import Core_RepositoryInterface
@testable import Feature_Products
import XCTest

final class AddReviewReducerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var initialState: AddReviewState = .init(
        productId: ""
    )
    private lazy var store: TestStore = {
        .init(
            initialState: initialState,
            reducer: addReviewReducer,
            environment: .dummy
        )
    }()
    private let testScheduler = DispatchQueue.test
    
    // MARK: - Tests

    func test_updateRating_shouldUpdateRatingValue() {
        // Given
        let ratingMock: Int = 3
        
        // When / Then
        store.send(.updateRating(ratingMock)) { newState in
            newState.rating = ratingMock
        }
    }
    
    func test_updateReviewText_shouldUpdateReviewText() {
        // Given
        let reviewTextMock: String = "this is just a mocked text"
        
        // When / Then
        store.send(.updateReviewText(reviewTextMock)) { newState in
            newState.reviewText = reviewTextMock
        }
    }
    
    func test_sendReview_whenSendingSucceds_shouldPerformSuccessAction() {
        // Given
        let localeMock: String = "pt-BR"
        var onSendReviewSuccessCalled: Bool = false
        let reviewRepositoryStub = ReviewRepositoryStub()
        reviewRepositoryStub.sendReviewResultToBeReturned = .success(())
        
        store.environment = .mocking(
            mainQueue: testScheduler.eraseToAnyScheduler(),
            locale: { localeMock },
            onSendReviewSuccess: { _ in
                onSendReviewSuccessCalled = true
            },
            reviewRepository: reviewRepositoryStub
        )
        
        // When / Then
        store.send(.sendReview) { newState in
            newState.isLoading = true
            newState.newReview = .fixture(
                locale: localeMock,
                rating: self.initialState.rating + 1
            )
        }
        testScheduler.advance()
        store.receive(.handleSendReview(.success(()))) { newState in
            newState.isLoading = false
            XCTAssertNil(newState.errorAlert)
            XCTAssertTrue(onSendReviewSuccessCalled)
        }
    }
    
    func test_sendReview_whenSendingFails_shouldDisplayErrorAlert() {
        // Given
        let localeMock: String = "pt-BR"
        var onSendReviewSuccessCalled: Bool = false
        let reviewRepositoryStub = ReviewRepositoryStub()
        let dummyError: NSError = .init(domain: "", code: -1)
        reviewRepositoryStub.sendReviewResultToBeReturned = .failure(dummyError)
        
        store.environment = .mocking(
            mainQueue: testScheduler.eraseToAnyScheduler(),
            locale: { localeMock },
            onSendReviewSuccess: { _ in
                onSendReviewSuccessCalled = true
            },
            reviewRepository: reviewRepositoryStub
        )
        
        // When / Then
        store.send(.sendReview) { newState in
            newState.isLoading = true
            newState.newReview = .fixture(
                locale: localeMock,
                rating: self.initialState.rating + 1
            )
        }
        testScheduler.advance()
        store.receive(.handleSendReview(.failure(dummyError))) { newState in
            newState.isLoading = false
            newState.errorAlert = .init(
                title: TextState(L10n.AddReview.Error.title),
                dismissButton: .default(
                    TextState(L10n.AddReview.Error.buttonTitle),
                    send: .onAppear
                )
            )

            XCTAssertFalse(onSendReviewSuccessCalled)
        }
    }
}
