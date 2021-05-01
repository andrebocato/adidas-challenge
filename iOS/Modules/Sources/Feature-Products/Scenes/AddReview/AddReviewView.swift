import Combine
import ComposableArchitecture
import Core_UI
import SwiftUI

struct AddReviewView: View {
    
    typealias AddReviewViewStore = ViewStore<AddReviewState, AddReviewAction>
    
    // MARK: - Dependencies
    
    private let store: Store<AddReviewState, AddReviewAction>
    
    // MARK: - Initializers
    
    init(store: Store<AddReviewState, AddReviewAction>) {
        self.store = store
    }
    
    // MARK: - Content View
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ratingContainer(with: viewStore)
                Divider()
                reviewTextContainer(with: viewStore)
                Spacer()
                sendReviewButton(with: viewStore)
            }
            .alert(
                store.scope(state: { $0.errorAlert }),
                dismiss: .onAppear
            )
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    @ViewBuilder
    private func ratingContainer(with viewStore: AddReviewViewStore) -> some View {
        VStack {
            Text(L10n.AddReview.Titles.rating)
                .font(.callout)
                .padding(.top, DS.Spacing.xxSmall)
            HStack {
                ForEach(0..<5) { index in
                    Button(
                        action: { viewStore.send(.updateRating(index)) }
                    ) {
                        Image(systemName: "star.fill")
                    }
                    .frame(
                        width: DS.LayoutSize.medium.width,
                        height: DS.LayoutSize.medium.height,
                        alignment: .center
                    )
                    .foregroundColor(.yellow)
                    .opacity(viewStore.rating == index ? 1 : 0.25)
                    .padding(.horizontal, DS.Spacing.small)
                }
            }
            .overlay(
                RoundedRectangle(
                    cornerRadius: DS.LayoutSize.medium.height/2,
                    style: .continuous
                )
                .stroke(Color.secondary)
            )
            .padding()
        }
        .padding()
    }
    
    // @FIXME: TextEditor borders are overflowing to the horizontal borders sometimes.
    // After some user interaction, it goes back to normal size.
    @ViewBuilder
    private func reviewTextContainer(with viewStore: AddReviewViewStore) -> some View {
        Text(L10n.AddReview.Titles.textReview)
            .font(.callout)
            .padding(.top, DS.Spacing.xxSmall)
        TextEditor(
            text: viewStore.binding(
                get: { $0.reviewText },
                send: { .updateReviewText($0) }
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: DS.CornerRadius.xxSmall,
                style: .continuous
            )
            .stroke(Color.secondary)
        )
        .padding(.horizontal, DS.Spacing.small)
    }
    
    @ViewBuilder
    private func sendReviewButton(with viewStore: AddReviewViewStore) -> some View {
        Group {
            if viewStore.isLoading {
                ActivityIndicator(style: .medium)
            } else {
                Button(
                    L10n.AddReview.Titles.sendButton,
                    action: { viewStore.send(.sendReview) }
                )
            }
        }
        .padding()
    }
}
