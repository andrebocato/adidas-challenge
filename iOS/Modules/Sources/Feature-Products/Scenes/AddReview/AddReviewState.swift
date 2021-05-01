import ComposableArchitecture

struct AddReviewState: Equatable {
    let productId: String
    var rating: Int = .zero
    var reviewText: String = ""
    var errorAlert: AlertState<AddReviewAction>?
    var isLoading: Bool = false
}
