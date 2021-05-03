import Core_UI
import SwiftUI

struct ProductListItemView: View {
    
    // MARK: - Properties
    
    let viewData: ViewData
    
    // MARK: - Content View
    
    var body: some View {
        HStack {
            RemoteImage(url: viewData.imageURL)
                .scaledToFill()
                .frame(
                    width: DS.LayoutSize.xLarge.width,
                    height: DS.LayoutSize.xLarge.height,
                    alignment: .center
                )
                .cornerRadius(DS.CornerRadius.xxSmall)
            
            VStack(alignment: .leading) {
                Text(viewData.name)
                    .font(.callout)
                    .bold()
                Text(viewData.description)
                    .font(.caption)
                    .italic()
                    .frame(alignment: .leading)
            }
            Spacer()
            Text(viewData.formattedPrice)
                .font(.callout)
        }
    }
}
