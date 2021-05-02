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
            VStack(alignment: .center) {
                productData(with: viewStore)
                Spacer()
                reviewsList(with: viewStore)
            }
            .padding()
            .navigationBarTitle(viewStore.viewData.productName)
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private func productData(with viewStore: ProductDetailViewStore) -> some View {
        RemoteImage(
            url: viewStore.viewData.productImageURL
        )
        .scaledToFill()
        .padding(.horizontal, DS.Spacing.medium)
        
        VStack {
            HStack {
                Text(viewStore.viewData.productName)
                Spacer()
                Text(String(viewStore.viewData.productPrice))
            }
            Spacer()
            Text(viewStore.viewData.productDescription)
        }
        .padding()
    }
    
    @ViewBuilder
    private func reviewsList(with viewStore: ProductDetailViewStore) -> some View {
        List(viewStore.viewData.reviews) { review in
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
}
