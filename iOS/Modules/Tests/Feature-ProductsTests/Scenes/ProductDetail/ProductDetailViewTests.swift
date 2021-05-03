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
        let mockProduct: Product = .fixture(
            name: "Product Name",
            description: "This is a description to the product.",
            imageURL: "www.dummy.com"
        )
        
        store = store.scope { _ in
            .init(
                productId: "",
                productName: "Product Name",
                reviews: [
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
                ],
                scene: .loadedProduct(
                    .init(
                        from: mockProduct,
                        formattedPrice: "€ 123,45"
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
}
