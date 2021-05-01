import Combine
import ComposableArchitecture

public typealias ProductsListReducer = Reducer<ProductsListState, ProductsListAction, ProductsListEnvironment>

public let productsListReducer = ProductsListReducer { state, action, environment in
    switch action {
    case .fetchList:
        state.scene = .loading
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
        state.scene = .error(message: error.localizedDescription) // @TODO: map error in a better way
        return .none
        
    case .listProducts:
        state.scene = .list
        return .none
    }
}
