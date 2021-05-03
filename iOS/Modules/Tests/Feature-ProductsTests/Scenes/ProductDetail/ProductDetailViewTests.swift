import ComposableArchitecture
import Core_RepositoryInterface
@testable import Feature_Products
import SnapshotTesting
import SwiftUI
import XCTest

// - NOTE: Snapshots recorded on iPhone 11 with iOS 14.5.

final class ProductDetailViewTests: XCTestCase {
    
    // MARK: - Properties
    
    private let isRecordModeEnabled = false
    
    private lazy var store: Store<ProductDetailState, ProductDetailAction> = {
        .init(
            initialState: .init(
                productId: "",
                productName: ""
            ),
            reducer: productDetailReducer,
            environment: .dummy
        )
    }()
    private lazy var sutContainer: UIViewController = {
        let hostingController: UIHostingController = .init(
            rootView: ProductDetailView(
                store: store
            )
        )
        hostingController.view.frame = UIScreen.main.bounds
        // @FIXME: Navigation bar title is not showing on snapshots.
//        let navigationController = UINavigationController(rootViewController: hostingController)
//        navigationController.navigationBar.prefersLargeTitles = true
        return hostingController
    }()
    private let mockProductViewData: ProductDetailState.ProductViewData = .init(
        from: .fixture(
            name: "Product Name",
            description: "This is a description to the product.",
            imageURL: "www.dummy.com"
        ),
        formattedPrice: "€ 123,45"
    )
    private let mockReviewsData: [ProductDetailState.ReviewViewData] = [
        .fixture(
            from: .fixture(rating: 5, text: "Review text 1"),
            id: "1"
        ),
        .fixture(
            from: .fixture(rating: 3, text: "Review text 2"),
            id: "2"
        ),
        .fixture(
            from: .fixture(rating: 4, text: "Review text 3"),
            id: "3"
        )
    ]
    
    // MARK: - Tests

    func test_snapshot_productDetail_loadingFetchProduct() {
        // Given
        store = store.scope { _ in
            .init(
                productId: "",
                productName: "Product Name",
                scene: .loadingProduct
            )
        }
        
        // When
        _ = sutContainer.view
        
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }
    
    // @TODO: mock image. it's currently displaying an activity indicator
    func test_snapshot_productDetail_loadedProduct() {
        // Given
        store = store.scope { _ in
            .init(
                productId: "",
                productName: "Product Name",
                reviews: self.mockReviewsData,
                scene: .loadedProduct(self.mockProductViewData)
            )
        }
        
        // When
        _ = sutContainer.view
        
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }
    
    func test_snapshot_productDetail_networkingError() {
        // Given
        store = store.scope { _ in
            .init(
                productId: "",
                productName: "Product Name",
                scene: .errorFetchingProduct(
                    message: L10n.ProductDetail.Error.networkingMessage
                )
            )
        }
        
        // When
        _ = sutContainer.view
        
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }
    
    func test_snapshot_productDetail_unexpectedError() {
        // Given
        store = store.scope { _ in
            .init(
                productId: "",
                productName: "Product Name",
                scene: .errorFetchingProduct(
                    message: L10n.ProductDetail.Error.unexpectedMessage
                )
            )
        }
        
        // When
        _ = sutContainer.view
        
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }
    
    func test_snapshot_reloadReviews_loading() {
        // Given
        store = store.scope { _ in
            .init(
                productId: "",
                productName: "Product Name",
                isReloadingReviews: true,
                scene: .loadedProduct(self.mockProductViewData)
            )
        }
        
        // When
        _ = sutContainer.view
        
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }
    
    // @TODO: study how to properly snapshot test alerts.
    // https://www.pointfree.co/episodes/ep86-swiftui-snapshot-testing#t657
    func test_snapshot_reloadReviews_error() {
        // Given
        store = store.scope { _ in
            .init(
                productId: "",
                productName: "Product Name",
                reviews: self.mockReviewsData,
                scene: .loadedProduct(self.mockProductViewData),
                errorAlert: .init(
                    title: TextState(L10n.ProductDetail.Error.reloadReviewsMessage),
                    dismissButton: .default(
                        TextState(L10n.ProductDetail.Titles.ok)
                    )
                )
            )
        }
        
        // When
        _ = sutContainer.view
        
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }
}
