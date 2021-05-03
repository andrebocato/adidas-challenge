import ComposableArchitecture
import Core_RepositoryInterface
@testable import Feature_Products
import SnapshotTesting
import SwiftUI
import XCTest

// - NOTE: Snapshots recorded on iPhone 11 with iOS 14.5.

final class ProductsListViewTests: XCTestCase {
    
    // MARK: - Properties
    
    private let isRecordModeEnabled = false
    
    private lazy var store: Store<ProductsListState, ProductsListAction> = {
        .init(
            initialState: .init(),
            reducer: productsListReducer,
            environment: .dummy
        )
    }()
    private lazy var sutContainer: UIViewController = {
        let hostingController: UIHostingController = .init(
            rootView: ProductsListView(
                store: store
            )
        )
        hostingController.view.frame = UIScreen.main.bounds
        return hostingController
    }()
    private let mockItemsViewData: [ProductListItemView.ViewData] = [
        .init(
            from: .fixture(
                id: "1",
                name: "Product Name 1",
                description: "Description for product 1",
                imageURL: "www.dummy.com"
            ),
            formattedPrice: "€ 123,45"
        ),
        .init(
            from: .fixture(
                id: "2",
                name: "Product Name 2",
                description: "Description for product 2",
                imageURL: "www.dummy.com"
            ),
            formattedPrice: "€ 123,45"
        ),
        .init(
            from: .fixture(
                id: "3",
                name: "Product Name 3",
                description: "Description for product 3",
                imageURL: "www.dummy.com"
            ),
            formattedPrice: "€ 123,45"
        )
    ]
    
    // MARK: - Tests

    // @FIXME: activity indicator is not showing
    func test_snapshot_productsList_loadingProducts() {
        // Given
        store = store.scope { _ in
            .init(
                scene: .loadingList
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
    
    // @FIXME: list content is not showing
    func test_snapshot_productsList_loadedProducts() {
        // Given
        store = store.scope { _ in
            .init(
                scene: .loadedList,
                itemsViewData: self.mockItemsViewData
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
    
    func test_snapshot_productsList_errorLoadingList() {
        // Given
        store = store.scope { _ in
            .init(
                scene: .errorFetchingList
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
    
    func test_snapshot_productsList_searchBarWithText() {
        // Given
        store = store.scope { _ in
            .init(
                scene: .loadedList,
                searchText: "Something being searched"
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
