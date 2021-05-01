import Combine
import ComposableArchitecture
import Core_RepositoryInterface
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
            NavigationView {
                Group {
                    switch viewStore.scene {
                    case .loadingList:
                        activityIndicator()
                    case .loadedList:
                        productsList(with: viewStore)
                    case .errorFetchingList:
                        errorView(with: viewStore)
                    }
                }
                .navigationBarTitle(L10n.ProductsList.Titles.products)
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
        VStack {
            SearchBar(
                text: viewStore.binding(
                    get: { $0.searchText },
                    send: { .updateSearchText($0) }
                )
            )
            
            Divider()
            
            if viewStore.isSearching {
                searchResultsList(products: viewStore.searchResults)
            } else {
                searchResultsList(products: viewStore.products)
            }
        }
    }

    @ViewBuilder
    private func searchResultsList(products: [Product]) -> some View {
        List(products) { product in
            // @FIXME: The last selected item is not being deselected upon returning to the list.
            // According to https://developer.apple.com/forums/thread/660468, might be an issue with a List inside a VStack
            // Tried to add `.id(UUID())` to the navigation link, did not work.
            NavigationLink(
                destination: ProductDetailView(
                    store: .init(
                        initialState: .init(viewData: .init(from: product)),
                        reducer: productDetailReducer,
                        environment: ProductDetailEnvironment()
                    )
                )
            ) {
                ProductListItemView(viewData: .init(from: product))
            }
        }
    }
    
    @ViewBuilder
    private func errorView(with viewStore: ProductsListViewStore) -> some View {
        FillerView(
            model: .init(
                title: L10n.ProductsList.Error.title,
                subtitle: L10n.ProductsList.Error.subtitle,
                image: .init(
                    sfSymbol: "exclamationmark.circle",
                    color: .red
                )
            ),
            actionButton: .init(
                text: L10n.ProductsList.Error.tryAgain,
                action: { viewStore.send(.fetchList) }
            )
        )
    }
}

