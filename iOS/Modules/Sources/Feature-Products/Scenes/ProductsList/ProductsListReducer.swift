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
    }
}
