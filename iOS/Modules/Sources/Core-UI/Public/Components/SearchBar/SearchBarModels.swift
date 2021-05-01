import Foundation

extension SearchBar {
    public struct Layout {
        let placeholder: String
        let cancelText: String
        
        public init(
            placeholder: String,
            cancelText: String
        ) {
            self.placeholder = placeholder
            self.cancelText = cancelText
        }
        
        public static let `default`: Self = .init(
            placeholder: "Search",
            cancelText: "Cancel"
        )
    }
}
