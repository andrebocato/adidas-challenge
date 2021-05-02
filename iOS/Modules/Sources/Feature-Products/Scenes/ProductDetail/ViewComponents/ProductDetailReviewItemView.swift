import SwiftUI

struct ProductDetailReviewItemView: View {
    
    // MARK: - Properties
    
    let viewData: ViewData
    
    // MARK: - Content View
    
    var body: some View {
        Text("\"\(viewData.text)\"")
            .font(.subheadline)
            .italic()
        Spacer()
        HStack {
            Text(viewData.rating)
            Image(systemName: "star.fill")
        }
    }
}
