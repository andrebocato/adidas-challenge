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
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(viewData.name)
                Text(viewData.description)
                Text(viewData.price)
            }
        }
    }
}
