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
                        addReviewButton(with: viewStore)
                    }
                case let .errorFetchingProduct(message):
                    ErrorFillerView(
                        title: L10n.ProductDetail.Error.title,
                        subtitle: message,
                        tryAgainAction: { viewStore.send(.fetchProduct) }
                    )
                }
            }
            .padding()
            .navigationBarTitle(viewStore.productName)
            .sheet(
                isPresented: .constant(viewStore.isPresentingAddReviewSheet),
                onDismiss: { viewStore.send(.dismissAddReviewSheet) },
                content: { addReviewView(with: viewStore) }
            )
            .alert(
                store.scope(state: { $0.errorAlert }),
                dismiss: .dismissErrorAlert
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
                Text(viewData.formattedPrice)
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
        if viewStore.isReloadingReviews {
            activityIndicator()
            
        } else {
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
        }
    }
    
    @ViewBuilder
    private func addReviewButton(with viewStore: ProductDetailViewStore) -> some View {
        ButtonWithIcon(
            text: L10n.ProductDetail.Titles.addReviewButton,
            sfSymbol: "pencil",
            action: { viewStore.send(.presentAddReviewSheet) }
        )
        .frame(alignment: .leading)
        .padding()
    }
    
    @ViewBuilder
    private func addReviewView(with viewStore: ProductDetailViewStore) -> some View {
        AddReviewView(
            store: .init(
                initialState: .init(productId: viewStore.productId),
                reducer: addReviewReducer,
                environment: AddReviewEnvironment(
                    onSendReviewSuccess: {
                        viewStore.send(.dismissAddReviewSheet)
                    }
                )
            )
        )
    }
}
