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
