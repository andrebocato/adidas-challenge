import Core_UI
import SwiftUI

struct ProductListItemView: View {
    
    // MARK: - Properties
    
    let viewData: ViewData
    
    // MARK: - Content View
    
    // @TODO: implement a good layout
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
                Text(viewData.description)
                Text(viewData.price)
            }
            Spacer()
        }
    }
}
