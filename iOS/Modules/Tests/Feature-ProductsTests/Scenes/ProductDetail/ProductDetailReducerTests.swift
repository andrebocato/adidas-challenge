import Combine
import ComposableArchitecture
import Core_RepositoryInterface
@testable import Feature_Products
import XCTest

final class ProductDetailReducerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var initialState: ProductDetailState = .init(
        productId: "",
        productName: ""
    )
    private lazy var store: TestStore = {
        .init(
            initialState: initialState,
            reducer: productDetailReducer,
            environment: .dummy
        )
    }()
    private let testScheduler = DispatchQueue.test
    private let productRepositoryStub = ProductRepositoryStub()
    private let reviewRepositoryStub = ReviewRepositoryStub()
    private let dummyError: NSError = .init(domain: "", code: -1)
    
    // MARK: - Tests

    func test_fetchProduct_whenFetchingSucceeds_andStoredProductIsNotNil_shouldDisplayData() {
        // Given
        let formattedPriceDummy: String = ""
        
        let mockProduct: Product = .fixture()
        let mockID: String = "mock_id"
        productRepositoryStub.fetchProductWithIDResultToBeReturned = .success(mockProduct)
        
        let expectedReviewsData: [ProductDetailState.ReviewViewData] = mockProduct.reviews.map {
            .init(
                from: $0,
                id: mockID
            )
        }
        let expectedViewData: ProductDetailState.ProductViewData = .init(
            from: mockProduct,
            formattedPrice: formattedPriceDummy
        )
        
        store.environment = .mocking(
            generateUUIDString: { mockID },
            mainQueue: testScheduler.eraseToAnyScheduler(),
            productRepository: productRepositoryStub
        )
        
        // When / Then
        store.send(.fetchProduct) { newState in
            XCTAssertNil(newState.product)
            newState.scene = .loadingProduct
        }
        testScheduler.advance()
        store.receive(.handleFetchProduct(.success(mockProduct))) { newState in
            newState.product = mockProduct
        }
        store.receive(.populateView) { newState in
            XCTAssertNotNil(newState.product)
            
            newState.reviews = expectedReviewsData
            newState.scene = .loadedProduct(expectedViewData)
        }
    }
    
    func test_populateView_whenStoredProductIsNil_shouldDisplayUnexpectedErrorInFullscreen() {
        // Given
        let unexpectedErrorMessage: String = L10n.ProductDetail.Error.unexpectedMessage
        
        let nilProduct: Product? = nil
        initialState.product = nilProduct
        
        // When / Then
        store.send(.populateView) { newState in
            XCTAssertNil(newState.product)
        }
        store.receive(.displayError(mode: .fullscreen, message: unexpectedErrorMessage)) { newState in
            newState.scene = .errorFetchingProduct(message: unexpectedErrorMessage)
        }
    }
    
    func test_fetchProduct_whenFetchingFails_shouldDisplayNetworkingErrorInFullscreen() {
        // Given
        let networkingErrorMessage: String = L10n.ProductDetail.Error.networkingMessage
        productRepositoryStub.fetchProductWithIDResultToBeReturned = .failure(dummyError)
        
        store.environment = .mocking(
            mainQueue: testScheduler.eraseToAnyScheduler(),
            productRepository: productRepositoryStub
        )
        
        // When / Then
        store.send(.fetchProduct) { newState in
            newState.scene = .loadingProduct
            XCTAssertNil(newState.product)
        }
        testScheduler.advance()
        store.receive(.handleFetchProduct(.failure(dummyError))) { newState in
            XCTAssertNil(newState.product)
        }
        store.receive(.displayError(mode: .fullscreen, message: networkingErrorMessage)) { newState in
            newState.scene = .errorFetchingProduct(message: networkingErrorMessage)
        }
    }
    
    func test_reviewPresentation_whenSheetIsPresented_shouldSetPresentationFlagToTrue() {
        // When / Then
        store.send(.presentAddReviewSheet) { newState in
            newState.isPresentingAddReviewSheet = true
        }
    }
    
    func test_reviewPresentation_whenSheetIsDismissed_shoulFetchReviews() {
        // When / Then
        store.send(.dismissAddReviewSheet) { newState in
            newState.isPresentingAddReviewSheet = false
        }
        store.receive(.fetchReviews) { newState in
            newState.isReloadingReviews = true
        }
    }
    
    func test_fetchReviews_whenFetchingSucceeds_andThereAreNoNewReviews_shouldNotUpdateReviewsList() {
        // Given
        let mockID: String = "mock_ID"
    
        let getReviewsResponse: [Review] = [
            .fixture(text: "review_text_1"),
            .fixture(text: "review_text_2")
        ]
        reviewRepositoryStub.getReviewsResultToBeReturned = .success(getReviewsResponse)

        let reviewsBeforeReloading: [ProductDetailState.ReviewViewData] = [
            .fixture(from: .fixture(text: "review_text_1"), id: mockID),
            .fixture(from: .fixture(text: "review_text_2"), id: mockID)
        ]
        let expectedReviewsAfterReloading: [ProductDetailState.ReviewViewData] = [
            .fixture(from: .fixture(text: "review_text_1"), id: mockID),
            .fixture(from: .fixture(text: "review_text_2"), id: mockID)
        ]
        
        initialState.reviews = reviewsBeforeReloading
        
        store.environment = .mocking(
            generateUUIDString: { mockID },
            mainQueue: testScheduler.eraseToAnyScheduler(),
            reviewRepository: reviewRepositoryStub
        )
        
        // When / Then
        store.send(.fetchReviews) { newState in
            newState.isReloadingReviews = true
        }
        testScheduler.advance()
        store.receive(.handleFetchReviews(.success(getReviewsResponse))) { newState in
            newState.isReloadingReviews = false
            newState.reviews = expectedReviewsAfterReloading
            
            XCTAssertEqual(
                reviewsBeforeReloading,
                expectedReviewsAfterReloading
            )
        }
    }
    
    func test_fetchReviews_whenFetchingSucceeds_andThereAreNewReviews_shouldUpdateReviewsList() {
        // Given
        let mockID: String = "mock_ID"
    
        let getReviewsResponse: [Review] = [
            .fixture(text: "review_text_1"),
            .fixture(text: "review_text_2"),
            .fixture(text: "this_one_is_new")
        ]
        reviewRepositoryStub.getReviewsResultToBeReturned = .success(getReviewsResponse)

        let reviewsBeforeReloading: [ProductDetailState.ReviewViewData] = [
            .fixture(from: .fixture(text: "review_text_1"), id: mockID),
            .fixture(from: .fixture(text: "review_text_2"), id: mockID)
        ]
        let expectedReviewsAfterReloading: [ProductDetailState.ReviewViewData] = [
            .fixture(from: .fixture(text: "review_text_1"), id: mockID),
            .fixture(from: .fixture(text: "review_text_2"), id: mockID),
            .fixture(from: .fixture(text: "this_one_is_new"), id: mockID)
        ]
        
        initialState.reviews = reviewsBeforeReloading
        
        store.environment = .mocking(
            generateUUIDString: { mockID },
            mainQueue: testScheduler.eraseToAnyScheduler(),
            reviewRepository: reviewRepositoryStub
        )
        
        // When / Then
        store.send(.fetchReviews) { newState in
            newState.isReloadingReviews = true
        }
        testScheduler.advance()
        store.receive(.handleFetchReviews(.success(getReviewsResponse))) { newState in
            newState.isReloadingReviews = false
            newState.reviews = expectedReviewsAfterReloading
            
            XCTAssertNotEqual(
                reviewsBeforeReloading,
                expectedReviewsAfterReloading
            )
        }
    }
    
    func test_fetchReviews_whenFetchingFails_shouldDisplayReviewReloadingErrorAsAlert() {
        // Given
        let reloadReviewErrorMessage: String = L10n.ProductDetail.Error.reloadReviewsMessage
        reviewRepositoryStub.getReviewsResultToBeReturned = .failure(dummyError)
        
        store.environment = .mocking(
            mainQueue: testScheduler.eraseToAnyScheduler(),
            reviewRepository: reviewRepositoryStub
        )
        
        // When / Then
        store.send(.fetchReviews) { newState in
            newState.isReloadingReviews = true
        }
        testScheduler.advance()
        store.receive(.handleFetchReviews(.failure(dummyError))) { newState in
            newState.isReloadingReviews = false
        }
        store.receive(.displayError(mode: .alert, message: reloadReviewErrorMessage)) { newState in
            newState.errorAlert = .init(
                title: TextState(reloadReviewErrorMessage),
                dismissButton: .default(
                    TextState(L10n.ProductDetail.Titles.ok)
                )
            )
        }
    }
    
    func test_dismissErrorAlert_shouldClearErrorAlertProperty() {
        // When / Then
        store.send(.dismissErrorAlert) { newState in
            newState.errorAlert = nil
        }
    }
}
