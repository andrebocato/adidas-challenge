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
                }
            )
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
        .cornerRadius(DS.CornerRadius.xxSmall)
        .padding(.horizontal, DS.Spacing.medium)
        
        VStack(alignment: .leading) {
            HStack {
                Text(viewData.productName)
                    .font(.callout)
                Spacer()
                Text(String(viewData.formattedPrice))
                    .font(.callout)
                Spacer()
            }
            Text(viewData.productDescription)
                .font(.caption)
                .italic()
                .frame(alignment: .leading)
                .padding(.top, DS.Spacing.small)
        }
        .padding(DS.Spacing.small)
    }
    
    @ViewBuilder
    private func reviewsList(with viewStore: ProductDetailViewStore) -> some View {
        HStack {
            Text("\(viewStore.reviews.count) customers reviewed this product")
                .foregroundColor(.secondary)
                .frame(alignment: .leading)
                .padding(.horizontal, DS.Spacing.small)
            Spacer()
        }
        
        List(viewStore.reviews) { review in
            ProductDetailReviewItemView(
                viewData: .init(
                    text: review.text,
                    rating: String(review.rating)
                )
            )
        }
        .overlay(
            RoundedRectangle(
                cornerRadius: DS.CornerRadius.xxSmall,
                style: .continuous
            )
            .stroke(Color.secondary)
        )
        .padding(.horizontal, DS.Spacing.small)
        
        Button( // @TODO: make this button into a component
            action: { viewStore.send(.presentAddReviewSheet) }
        ) {
            HStack(alignment: .center) {
                Text(L10n.ProductDetail.Titles.addReviewButton)
                    .bold()
                Image(systemName: "pencil")
            }
            .padding()
            .background(Color.blue)
            .overlay(
                RoundedRectangle(
                    cornerRadius: DS.CornerRadius.small,
                    style: .continuous
                )
                .stroke(Color.blue)
            )
            .foregroundColor(.white)
            .cornerRadius(DS.CornerRadius.small)
        }
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
