import Core_RepositoryInterface

public struct ProductsListState: Equatable {
    var scene: Scene = .loading
    var products: [Product] = []
    
    public init() { }
}

// MARK: - Scene

extension ProductsListState {
    public enum Scene: Equatable {
        case loading
        case list
        case error(message: String)
    }
}

// MARK: - Identifiable

extension Product: Identifiable { }
