import Combine
import ComposableArchitecture
import Core_RepositoryInterface
@testable import Feature_Products
import XCTest

final class ProductsListReducerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var initialState: ProductsListState = .init()
    private lazy var store: TestStore = {
        .init(
            initialState: initialState,
            reducer: productsListReducer,
            environment: .dummy
        )
    }()
    private let testScheduler = DispatchQueue.test
    private let productRepositoryStub = ProductRepositoryStub()
    private let dummyError: NSError = .init(domain: "", code: -1)
    
    // MARK: - Tests

    func test_fetchList_whenFetchingSucceeds_shouldStoreProductsList() {
        // Given
        let productListMock: [Product] = [.fixture(), .fixture(), .fixture()]
        productRepositoryStub.fetchProductListResultToBeReturned = .success(productListMock)
        
        store.environment = .mocking(
            mainQueue: testScheduler.eraseToAnyScheduler(),
            productsListRepository: productRepositoryStub
        )
        
        // When / Then
        store.send(.fetchList) { newState in
            newState.scene = .loadingList
            XCTAssertTrue(newState.products.isEmpty)
        }
        testScheduler.advance()
        store.receive(.handleList(.success(productListMock))) { newState in
            newState.products = productListMock
            XCTAssertFalse(newState.products.isEmpty)
        }
        store.receive(.listProducts) { newState in
            newState.scene = .loadedList
        }
    }
    
    func test_fetchList_whenFetchingFails_shouldDisplayErrorView() {
        // Given
        productRepositoryStub.fetchProductListResultToBeReturned = .failure(dummyError)
        
        store.environment = .mocking(
            mainQueue: testScheduler.eraseToAnyScheduler(),
            productsListRepository: productRepositoryStub
        )
        
        // When / Then
        store.send(.fetchList) { newState in
            newState.scene = .loadingList
            XCTAssertTrue(newState.products.isEmpty)
        }
        testScheduler.advance()
        store.receive(.handleList(.failure(dummyError))) { newState in
            newState.scene = .errorFetchingList
            XCTAssertTrue(newState.products.isEmpty)
        }
    }
    
    func test_search_whenSearchTextIsEmpty_shouldReturnNoResults() {
        // Given
        let emptySearchText: String = ""
        
        // When / Then
        store.send(.updateSearchText(emptySearchText)) { newState in
            XCTAssertTrue(newState.searchText.isEmpty)
            
            newState.searchText = emptySearchText
            XCTAssertTrue(newState.searchText.isEmpty)
            XCTAssertTrue(newState.searchResults.isEmpty)
        }
    }
    
    func test_search_whenSearchTextIsNotEmpty_andThereAreSearchResults_shouldReturnFilteredProducts() {
        // Given
        let searchTextMock: String = "product 1"
        
        let productListMock: [Product] = [
            .fixture(name: "product 1"),
            .fixture(name: "product 2"),
            .fixture(name: "product 3")
        ]
        initialState = .init(
            products: productListMock
        )
        
        // When / Then
        store.send(.updateSearchText(searchTextMock)) { newState in
            XCTAssertTrue(newState.searchText.isEmpty)
            XCTAssertTrue(newState.searchResults.isEmpty)
            
            newState.searchText = searchTextMock
            XCTAssertFalse(newState.searchText.isEmpty)
            
            let filteredProducts = newState.products.filter {
                $0.description.contains(newState.searchText)
                    || $0.id.contains(newState.searchText)
                    || $0.name.contains(newState.searchText)
            }
            newState.searchResults = filteredProducts
            XCTAssertFalse(newState.searchResults.isEmpty)
        }
    }
    
    func test_search_whenSearchTextIsNotEmpty_andThereAreNoSearchResults_shouldReturnNoResults() {
        // Given
        let searchTextMock: String = "there is no product with this name"
        
        let productListMock: [Product] = [
            .fixture(name: "product 1"),
            .fixture(name: "product 2"),
            .fixture(name: "product 3")
        ]
        initialState = .init(
            products: productListMock
        )
        
        // When / Then
        store.send(.updateSearchText(searchTextMock)) { newState in
            XCTAssertTrue(newState.searchText.isEmpty)
            XCTAssertTrue(newState.searchResults.isEmpty)
            
            newState.searchText = searchTextMock
            XCTAssertFalse(newState.searchText.isEmpty)
            
            let filteredProducts = newState.products.filter {
                $0.description.contains(newState.searchText)
                    || $0.id.contains(newState.searchText)
                    || $0.name.contains(newState.searchText)
            }
            newState.searchResults = filteredProducts
            XCTAssertTrue(newState.searchResults.isEmpty)
        }
    }
}
