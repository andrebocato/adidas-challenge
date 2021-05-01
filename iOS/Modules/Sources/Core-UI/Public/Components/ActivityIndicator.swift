import SwiftUI

/// Activity Indicator made from a `UIActivityIndicator`
public struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style

    public init(style: UIActivityIndicatorView.Style = .large) {
        self.style = style
    }
    
    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
         uiView.startAnimating()
    }
}
