import SwiftUI

public struct FillerView: View {
    
    // MARK: - Properties
    
    private let model: Model
    private var actionButton: ActionButton?
    
    // MARK: - Initializer
    
    public init(
        model: Model,
        actionButton: ActionButton? = nil
    ) {
        self.model = model
        self.actionButton = actionButton
    }
    
    // MARK: - UI
    
    public var body: some View {
        VStack(spacing: DS.Spacing.base) {
            if let image = model.image {
                Image(systemName: image.sfSymbol)
                    .resizable()
                    .frame(
                        width: DS.LayoutSize.large.width,
                        height: DS.LayoutSize.large.height
                    )
                    .foregroundColor(image.color)
            }
            
            VStack(spacing: DS.Spacing.xSmall) {
                Text(model.title)
                    .foregroundColor(.primary)
                    .bold()
                
                if let subtitle = model.subtitle {
                    Text(subtitle)
                        .foregroundColor(.primary)
                }
            }
            .multilineTextAlignment(.center)
            
            if let actionButton = actionButton {
                Button(
                    actionButton.text,
                    action: actionButton.action
                )
            }
        }
        .alignmentGuide(VerticalAlignment.center) { $0[VerticalAlignment.center] * 1.1 }
        .padding(DS.Spacing.medium)
        .frame(
            minWidth: .zero,
            maxWidth: .infinity,
            minHeight: .zero,
            maxHeight: .infinity
        )
    }
}
