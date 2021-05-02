import Combine
import ComposableArchitecture
import Core_UI
import SwiftUI

struct ProductDetailView: View {
    
    typealias ProductDetailViewStore = ViewStore<ProductDetailState, ProductDetailAction>
    
    // MARK: - Dependencies
    
    private let store: Store<ProductDetailState, ProductDetailAction>
    
    // MARK: - Initializers
    
    init(store: Store<ProductDetailState, ProductDetailAction>) {
        self.store = store
    }
    
    // MARK: - Content View
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                switch viewStore.scene {
                case .loadingProduct:
                    activityIndicator()
                case let .loadedProduct(viewData):
                    VStack(alignment: .center) {
                        productData(with: viewData)
                        Spacer()
                        reviewsList(with: viewStore)
                    }
                case let .errorFetchingProduct(message):
                    errorView(with: viewStore, message: message)
                }
            }
            .padding()
            .navigationBarTitle(viewStore.productName)
            .onAppear { viewStore.send(.fetchProduct) }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private func activityIndicator() -> some View {
        Spacer()
        ActivityIndicator()
        Spacer()
    }
    
    @ViewBuilder
    private func productData(with viewData: ProductDetailState.ProductViewData) -> some View {
        RemoteImage(
            url: viewData.productImageURL
        )
        .scaledToFill()
        .padding(.horizontal, DS.Spacing.medium)
        
        VStack {
            HStack {
                Text(viewData.productName)
                Spacer()
                Text(String(viewData.productPrice))
            }
            Spacer()
            Text(viewData.productDescription)
        }
        .padding()
    }
    
    @ViewBuilder
    private func reviewsList(with viewStore: ProductDetailViewStore) -> some View {
        List(viewStore.reviews) { review in
            Text(review.text)
        }
        
        Button(L10n.ProductDetail.Titles.addReviewButton) {
            viewStore.send(.presentAddReviewSheet)
        }
        .sheet(
            isPresented: .constant(viewStore.isPresentingAddReviewSheet),
            onDismiss: { viewStore.send(.dismissAddReviewSheet()) },
            content: {
                AddReviewView(
                    store: .init(
                        initialState: .init(productId: viewStore.productId),
                        reducer: addReviewReducer,
                        environment: AddReviewEnvironment(
                            onSendReviewSuccess: { newReview in
                                viewStore.send(.dismissAddReviewSheet(newReview: newReview))
                            }
                        )
                    )
                )
            })
        .frame(alignment: .leading)
        .padding()
    }
    
    @ViewBuilder
    private func errorView(with viewStore: ProductDetailViewStore, message: String) -> some View {
        FillerView(
            model: .init(
                title: L10n.ProductDetail.Error.title,
                subtitle: message,
                image: .init(
                    sfSymbol: "exclamationmark.circle",
                    color: .red
                )
            ),
            actionButton: .init(
                text: L10n.ProductDetail.Error.tryAgain,
                action: { viewStore.send(.fetchProduct) }
            )
        )
    }
}
