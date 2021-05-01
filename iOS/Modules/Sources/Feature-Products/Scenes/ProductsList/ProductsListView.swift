import Combine
import ComposableArchitecture
import Core_UI
import SwiftUI

public struct ProductsListView: View {

    typealias ProductsListViewStore = ViewStore<ProductsListState, ProductsListAction>
    
    // MARK: - Dependencies

    private let store: Store<ProductsListState, ProductsListAction>

    // MARK: - Initializers

    public init(store: Store<ProductsListState, ProductsListAction>) {
        self.store = store
    }

    // MARK: - Content View

    public var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                switch viewStore.scene {
                case .loading:
                    activityIndicator()
                case .list:
                    productsList(with: viewStore)
                case let .error(message):
                    errorView(with: viewStore, message)
                }
            }
            .onAppear { viewStore.send(.fetchList) }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private func activityIndicator() -> some View {
        Spacer()
        ActivityIndicator()
            .navigationBarBackButtonHidden(true)
        Spacer()
    }
    
    @ViewBuilder
    private func productsList(with viewStore: ProductsListViewStore) -> some View {
        List(viewStore.products) { item in
            ProductListItemView(viewData: .init(from: item))
        }
    }

    @ViewBuilder
    private func errorView(with viewStore: ProductsListViewStore, _ message: String) -> some View {
        Text(message) // @TODO: show error in a decent way. and allow user to retry request
    }
}

