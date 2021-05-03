import SwiftUI

public struct ErrorFillerView: View {
    
    // MARK: - Properties

    private let title: String
    private let subtitle: String?
    private let image: ImageResource
    private let tryAgainAction: () -> Void
    
    // MARK: - Initializers
    
    /// Pre-implemented `FillerView` for displaying errors.
    public init(
        title: String,
        subtitle: String? = nil,
        image: ImageResource = .init(
            sfSymbol: "exclamationmark.circle",
            color: .red
        ),
        tryAgainAction: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.tryAgainAction = tryAgainAction
    }
    
    // MARK: - UI
    
    public var body: some View {
        FillerView(
            model: .init(
                title: title,
                subtitle: subtitle,
                image: image
            ),
            actionButton: .init(
                text: "Try again",
                action: tryAgainAction
            )
        )
    }
    
}
