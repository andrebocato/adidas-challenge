import SwiftUI

extension FillerView {
    
    public struct Model {
        public let title: String
        public let subtitle: String?
        public let image: ImageResource?
        
        public init(
            title: String,
            subtitle: String? = nil,
            image: ImageResource? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.image = image
        }
        
        public struct ImageResource {
            /// This is related to `systemName`, please check SFSymbols
            public let sfSymbol: String
            public let color: Color?
            
            public init(
                sfSymbol: String,
                color: Color = .secondary
            ) {
                self.sfSymbol = sfSymbol
                self.color = color
            }
        }
    }
    
    public struct ActionButton {
        public let text: String
        public let action: () -> Void
        
        public init(
            text: String,
            action: @escaping () -> Void
        ) {
            self.text = text
            self.action = action
        }
    }
}
