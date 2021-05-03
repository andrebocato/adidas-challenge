import ComposableArchitecture
import Core_RepositoryInterface
@testable import Feature_Products
import SnapshotTesting
import SwiftUI
import XCTest

// - NOTE: Snapshots recorded on iPhone 11 with iOS 14.5.

final class AddReviewViewTests: XCTestCase {
    
    // MARK: - Properties
    
    private let isRecordModeEnabled = false
    
    private lazy var store: Store<AddReviewState, AddReviewAction> = {
        .init(
            initialState: .init(
                productId: ""
            ),
            reducer: addReviewReducer,
            environment: .dummy
        )
    }()
    private lazy var sutContainer: UIViewController = {
        let hostingController: UIHostingController = .init(
            rootView: AddReviewView(
                store: store
            )
        )
        hostingController.view.frame = UIScreen.main.bounds
        return hostingController
    }()
    
    // MARK: - Tests

    func test_snapshot_addReview_emptyRatingAndText() {
        // Given
        store = store.scope { _ in
            .init(
                productId: "",
                rating: nil,
                reviewText: ""
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
    
    func test_snapshot_addReview_someRatingAndSomeText() {
        // Given
        store = store.scope { _ in
            .init(
                productId: "",
                rating: 3, // Will actually display this value + 1
                reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
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
    
    func test_snapshot_addReview_loading() {
        // Given
        store = store.scope { _ in
            .init(
                productId: "",
                isLoading: true
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
    
