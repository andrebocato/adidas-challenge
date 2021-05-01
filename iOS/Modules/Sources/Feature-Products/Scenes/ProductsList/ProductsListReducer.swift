import Combine
import ComposableArchitecture

public typealias ProductsListReducer = Reducer<ProductsListState, ProductsListAction, ProductsListEnvironment>

public let productsListReducer = ProductsListReducer { state, action, environment in
    switch action {
    case .fetchList:
        state.scene = .loadingList
        return environment
            .productsListRepository
            .fetchProductsList()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(ProductsListAction.handleList)
        
    case let .handleList(.success(response)):
        state.products = response
        return .init(value: .listProducts)
        
    case let .handleList(.failure(error)):
        state.scene = .errorFetchingList
        return .none
        
    case .listProducts:
        state.scene = .loadedList
        return .none
        
    case let .updateSearchText(text):
        state.searchText = text
        
        guard !text.isEmpty else {
            return .none
        }
        
        let searchResults = state.products.filter {
            $0.description.contains(text) || $0.id.contains(text) || $0.name.contains(text)
        }
        state.searchResults = searchResults
        return .none
    }
}
