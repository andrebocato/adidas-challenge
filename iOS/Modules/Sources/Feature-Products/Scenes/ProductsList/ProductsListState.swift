import Core_RepositoryInterface

public struct ProductsListState: Equatable {
    var scene: Scene = .loadingList
    var products: [Product] = []
    var searchText: String = ""
    var searchResults: [Product] = []
    
    var isSearching: Bool { !searchText.isEmpty }
    
    public init(
        products: [Product] = []
    ) {
        self.products = products
    }
}

// MARK: - Scene

extension ProductsListState {
    public enum Scene: Equatable {
        case loadingList
        case loadedList
        case errorFetchingList
    }
}

// MARK: - Identifiable

extension Product: Identifiable { }
