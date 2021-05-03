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
                        ErrorFillerView(
                            title: L10n.ProductsList.Error.title,
                            subtitle: L10n.ProductsList.Error.subtitle,
                            tryAgainAction: { viewStore.send(.fetchList) }
                        )
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
            searchResultsList(with: viewStore)
        }
        .navigationBarItems(
            trailing: Button(
                action: { viewStore.send(.fetchList) },
                label: {
                    Image(systemName: "arrow.clockwise")
                }
            )
        )
    }

    @ViewBuilder
    private func searchResultsList(with viewStore: ProductsListViewStore) -> some View {
        let products = viewStore.isSearching ? viewStore.searchResults : viewStore.products
        let productsWithIndex = products.enumerated().map { $0 }
        List(productsWithIndex, id: \.element.id) { index, product in
            // @FIXME: The last selected item is not being deselected upon returning to the list.
            // According to https://developer.apple.com/forums/thread/660468, might be an issue with a List inside a VStack
            // Tried to add `.id(UUID())` to the navigation link, did not work.
            NavigationLink(
                destination: ProductDetailView(
                    store: .init(
                        initialState: .init(
                            productId: product.id,
                            productName: product.name
                        ),
                        reducer: productDetailReducer,
                        environment: .init()
                    )
                )
            ) {
                ProductListItemView(viewData: viewStore.itemsViewData[index])
            }
        }
    }
}

