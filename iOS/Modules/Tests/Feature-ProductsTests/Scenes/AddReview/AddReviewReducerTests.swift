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
    private let reviewRepositoryStub = ReviewRepositoryStub()
    
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
    
    func test_sendReview_whenRatingIsNil_shouldDisplayNoRatingError() {
        // Given
        let noRatingErrorMessage: String = L10n.AddReview.Error.noRatingMessage
        initialState.rating = nil
        
        // When / Then
        store.send(.sendReview) { newState in
            newState.isLoading = true
            XCTAssertNil(newState.rating)
        }
        store.receive(.showErrorAlert(message: noRatingErrorMessage)) { newState in
            newState.errorAlert = .init(
                title: TextState(noRatingErrorMessage),
                dismissButton: .default(
                    TextState(L10n.AddReview.Error.buttonTitle)
                )
            )
        }
    }
    
    func test_sendReview_whenReviewTextIsEmpty_shouldDisplayNoTextError() {
        // Given
        let noTextErrorMessage: String = L10n.AddReview.Error.noTextMessage
        initialState.rating = 1
        initialState.reviewText = ""
        
        // When / Then
        store.send(.sendReview) { newState in
            newState.isLoading = true
            
            guard self.initialState.rating != nil else {
                XCTFail("Rating value should not be nil in this scenario. Assign it in the test setup.")
                return
            }
            
            XCTAssertTrue(newState.reviewText.isEmpty)
        }
        store.receive(.showErrorAlert(message: noTextErrorMessage)) { newState in
            newState.errorAlert = .init(
                title: TextState(noTextErrorMessage),
                dismissButton: .default(
                    TextState(L10n.AddReview.Error.buttonTitle)
                )
            )
        }
    }
    
    func test_sendReview_whenRatingAndReviewAreValid_andSendingSucceds_shouldPerformSuccessAction() {
        // Given
        let localeMock: String = "pt-BR"
        var onSendReviewSuccessCalled: Bool = false
        reviewRepositoryStub.sendReviewResultToBeReturned = .success(())
        
        let mockRating: Int = 2
        initialState.rating = mockRating
        let mockReviewText: String = "mock text"
        initialState.reviewText = mockReviewText
        
        store.environment = .mocking(
            mainQueue: testScheduler.eraseToAnyScheduler(),
            locale: { localeMock },
            onSendReviewSuccess: {
                onSendReviewSuccessCalled = true
            },
            reviewRepository: reviewRepositoryStub
        )

        // When / Then
        store.send(.sendReview) { newState in
            newState.isLoading = true
            
            guard let initialRating = self.initialState.rating else {
                XCTFail("Rating value should not be nil in this scenario. Assign it in the test setup.")
                return
            }
            guard !self.initialState.reviewText.isEmpty else {
                XCTFail("Text value should not be empty this scenario. Assign it in the test setup.")
                return
            }
            
            newState.newReview = .fixture(
                locale: localeMock,
                rating: initialRating + 1,
                text: mockReviewText
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
        
        let mockRating: Int = 2
        initialState.rating = mockRating
        let mockReviewText: String = "mock text"
        initialState.reviewText = mockReviewText
        
        let dummyError: NSError = .init(domain: "", code: -1)
        reviewRepositoryStub.sendReviewResultToBeReturned = .failure(dummyError)
        let networkingErrorMessage: String = L10n.AddReview.Error.networkingMessage

        store.environment = .mocking(
            mainQueue: testScheduler.eraseToAnyScheduler(),
            locale: { localeMock },
            onSendReviewSuccess: {
                onSendReviewSuccessCalled = true
            },
            reviewRepository: reviewRepositoryStub
        )
        
        // When / Then
        store.send(.sendReview) { newState in
            newState.isLoading = true
            
            guard let initialRating = self.initialState.rating else {
                XCTFail("Rating value should not be nil in this scenario. Assign it in the test setup.")
                return
            }
            guard !self.initialState.reviewText.isEmpty else {
                XCTFail("Text value should not be empty this scenario. Assign it in the test setup.")
                return
            }
            
            newState.newReview = .fixture(
                locale: localeMock,
                rating: initialRating + 1,
                text: mockReviewText
            )
        }
        testScheduler.advance()
        store.receive(.handleSendReview(.failure(dummyError))) { newState in
            newState.isLoading = false
        }
        store.receive(.showErrorAlert(message: networkingErrorMessage)) { newState in
            newState.errorAlert = .init(
                title: TextState(networkingErrorMessage),
                dismissButton: .default(
                    TextState(L10n.AddReview.Error.buttonTitle)
                )
            )
            XCTAssertFalse(onSendReviewSuccessCalled)
        }
    }
    
    func test_dismissErrorAlert_shouldClearErrorAlertVariableAndStopLoading() {
        // When / Then
        store.send(.dismissErrorAlert) { newState in
            newState.isLoading = false
            newState.errorAlert = nil
        }
    }
}
