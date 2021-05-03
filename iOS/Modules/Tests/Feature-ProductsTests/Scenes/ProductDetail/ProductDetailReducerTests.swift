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
    
    // MARK: - Tests

    func test_fetchProduct_whenFetchingSucceeds_andStoredProductIsNotNil_shouldDisplayData() {
        // Given
        let formattedPriceDummy: String = ""
        
        let mockProduct: Product = .fixture()
        let mockID: String = "mock_id"
        productRepositoryStub.fetchProductWithIDResultToBeReturned = .success(mockProduct)
        
        store.environment = .mocking(
            generateUUIDString: { mockID },
            mainQueue: testScheduler.eraseToAnyScheduler(),
            productRepository: productRepositoryStub
        )
        
        // When / Then
        store.send(.fetchProduct) { newState in
            newState.scene = .loadingProduct
            XCTAssertNil(newState.product)
        }
        testScheduler.advance()
        store.receive(.handleFetchProduct(.success(mockProduct))) { newState in
            newState.product = mockProduct
        }
        store.receive(.populateView) { newState in
            XCTAssertNotNil(newState.product)
            
            newState.reviews = mockProduct.reviews.map {
                .init(
                    from: $0,
                    id: mockID
                )
            }
            
            let viewData: ProductDetailState.ProductViewData = .init(
                from: mockProduct,
                formattedPrice: formattedPriceDummy
            )
            newState.scene = .loadedProduct(viewData)
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
        
        let dummyError: NSError = .init(domain: "", code: -1)
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
    
    func test_reviewPresentation_whenSheetIsDismissed_andNoReviewIsPassed_shouldNotAddReviewToReviewsDataList() {
//        // Given
//        let nilReview: Review? = nil
//        initialState.reviews = [.fixture(), .fixture(), .fixture()]
//
//        // When
//        store.send(.dismissAddReviewSheet(newReview: nilReview)) { newState in
//            newState.isPresentingAddReviewSheet = false
//
//            // Then
//            XCTAssertEqual(
//                self.initialState.reviews,
//                newState.reviews
//            )
//        }
    }
    
    func test_reviewPresentation_whenSheetIsDismissed_andAReviewIsPassed_shouldAppendNewReviewToReviewsDataList() {
//        // Given
//        let newReview: Review = .fixture()
//        let mockID: String = "mock_id"
//
//        let initialReviewsViewData: [ProductDetailState.ReviewViewData] = [
//            .fixture(id: mockID),
//            .fixture(id: mockID),
//            .fixture(id: mockID)
//        ]
//        initialState.reviews = initialReviewsViewData
//        store.environment = .mocking(
//            generateUUIDString: { mockID }
//        )
//
//        // When
//        store.send(.dismissAddReviewSheet(newReview: newReview)) { newState in
//            newState.isPresentingAddReviewSheet = false
//
//            var updatedReviewsViewData = initialReviewsViewData
//            updatedReviewsViewData.append(
//                .init(
//                    from: newReview,
//                    id: mockID
//                )
//            )
//
//            newState.reviews = updatedReviewsViewData
//
//            // Then
//            XCTAssertEqual(
//                newState.reviews.count,
//                self.initialState.reviews.count + 1
//            )
//        }
    }
}
