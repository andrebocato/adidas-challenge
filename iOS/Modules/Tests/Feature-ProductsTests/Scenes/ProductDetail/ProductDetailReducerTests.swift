import Combine
import ComposableArchitecture
import Core_RepositoryInterface
@testable import Feature_Products
import XCTest

final class ProductDetailReducerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var initialState: ProductDetailState = .init(
        product: .fixture(),
        productViewData: .init(from: .fixture())
    )
    private lazy var store: TestStore = {
        .init(
            initialState: initialState,
            reducer: productDetailReducer,
            environment: .dummy
        )
    }()
    
    // MARK: - Tests
    
    func test_onAppear_shouldPopulateReviewsViewData() {
        // Given
        let productMock: Product = .fixture(
            reviews: [
                .fixture(
                    productId: "same_id",
                    locale: "locale_1",
                    rating: 1,
                    text: "review_text_1"
                ),
                .fixture(
                    productId: "same_id",
                    locale: "locale_2",
                    rating: 2,
                    text: "review_text_2"
                ),.fixture(
                    productId: "same_id",
                    locale: "locale_3",
                    rating: 3,
                    text: "review_text_3"
                )
            ]
        )
        let dummyProductViewData: ProductDetailState.ProductViewData = .init(from: .fixture())
        initialState = .init(
            product: productMock,
            productViewData: dummyProductViewData
        )
        
        let mockID: String = "mocked_id"
        store.environment = .mocking(
            generateUUIDString: { mockID }
        )
        
        let expectedReviewsViewData: [ProductDetailState.ReviewViewData] = productMock
            .reviews
            .map {
                .init(
                    from: $0,
                    id: mockID
                )
            }
        
        // When / Then
        store.send(.onAppear) { newState in
            XCTAssertTrue(newState.reviewsViewData.isEmpty)
            newState.reviewsViewData = expectedReviewsViewData
            
            XCTAssertFalse(newState.reviewsViewData.isEmpty)
            XCTAssertEqual(
                newState.reviewsViewData,
                expectedReviewsViewData
            )
        }
    }
    
    func test_reviewPresentation_whenSheetIsPresented_shouldSetPresentationFlagToTrue() {
        // When / Then
        store.send(.presentAddReviewSheet) { newState in
            newState.isPresentingAddReviewSheet = true
        }
    }
    
    func test_reviewPresentation_whenSheetIsDismissed_andNoReviewIsPassed_shouldNotAddReviewToReviewsDataList() {
        // Given
        let nilReview: Review? = nil
        
        let dummyProduct: Product = .fixture()
        initialState = .init(
            product: dummyProduct,
            productViewData: .init(from: dummyProduct),
            reviewsViewData: [
                .init(
                    from: .fixture(),
                    id: "dummy_id"
                ),
                .init(
                    from: .fixture(),
                    id: "dummy_id"
                ),
                .init(
                    from: .fixture(),
                    id: "dummy_id"
                )
            ]
        )
        
        // When
        store.send(.dismissAddReviewSheet(newReview: nilReview)) { newState in
            newState.isPresentingAddReviewSheet = false
            
            // Then
            XCTAssertEqual(
                self.initialState.reviewsViewData,
                newState.reviewsViewData
            )
        }
    }
    
    func test_reviewPresentation_whenSheetIsDismissed_andAReviewIsPassed_shouldAppendNewReviewToReviewsDataList() {
        // Given
        let newReview: Review = .fixture()
        let mockID: String = "mock_id"
        
        let dummyProduct: Product = .fixture()
        let initialReviewsViewData: [ProductDetailState.ReviewViewData] = [
            .init(
                from: .fixture(),
                id: mockID
            ),
            .init(
                from: .fixture(),
                id: mockID
            ),
            .init(
                from: .fixture(),
                id: mockID
            )
        ]
        initialState = .init(
            product: dummyProduct,
            productViewData: .init(from: dummyProduct),
            reviewsViewData: initialReviewsViewData
        )
        store.environment = .mocking(
            generateUUIDString: { mockID }
        )
        
        // When
        store.send(.dismissAddReviewSheet(newReview: newReview)) { newState in
            newState.isPresentingAddReviewSheet = false
            
            var updatedReviewsViewData = initialReviewsViewData
            updatedReviewsViewData.append(
                .init(
                    from: newReview,
                    id: mockID
                )
            )
            
            newState.reviewsViewData = updatedReviewsViewData
            
            // Then
            XCTAssertEqual(
                newState.reviewsViewData.count,
                self.initialState.reviewsViewData.count + 1
            )
        }

    }
}
