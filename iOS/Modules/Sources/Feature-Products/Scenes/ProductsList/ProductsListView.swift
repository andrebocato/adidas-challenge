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
        List(viewStore.products) { product in
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
        .padding(.zero)
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

