import Core_RepositoryInterface
@testable import Feature_Products
import SnapshotTesting
import SwiftUI
import XCTest

// - NOTE: Snapshots recorded on iPhone 11 with iOS 14.5.

final class ProductListItemViewTests: XCTestCase {
    
    // MARK: - Properties
    
    private let isRecordModeEnabled = false
    
    private lazy var sutContainer: UIViewController = {
        let hostingController: UIHostingController = .init(
            rootView: ProductListItemView(
                viewData: .init(
                    from: .fixture(
                        name: "Product Name 1",
                        description: "Description for product 1",
                        imageURL: "www.dummy.com"
                    ),
                    formattedPrice: "€ 123,45"
                )
            )
        )
        hostingController.view.frame = UIScreen.main.bounds
        return hostingController
    }()
    
    // MARK: - Tests
    
    func test_snapshot_productsListItem() {
        // Given / When
        _ = sutContainer.view
        
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }
}
