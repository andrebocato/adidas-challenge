import SwiftUI

public struct ButtonWithIcon: View {
    
    // MARK: - Properties
    
    private let text: String
    private let sfSymbol: String
    private let foregroundColor: Color
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let action: () -> Void
    
    // MARK: - Initializer
    
    /// A button with round corners, solid background, text in the center and icon on the right.
    /// - Parameters:
    ///   - text: The central text to be displayed.
    ///   - sfSymbol: The icon to be displayed on the right of the text. Accepts `SFSymbol`s.
    ///   - foregroundColor: The color of the text and icon.
    ///   - backgroundColor: The color to be on the background and borders.
    ///   - cornerRadius: The corners radii.
    ///   - action: The action to be performed.
    public init(
        text: String,
        sfSymbol: String,
        foregroundColor: Color = .white,
        backgroundColor: Color = .blue,
        cornerRadius: CGFloat = DS.CornerRadius.small,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.sfSymbol = sfSymbol
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    // MARK: - UI
    
    public var body: some View {
        Button(
            action: action
        ) {
            HStack(alignment: .center) {
                Text(text)
                    .bold()
                Image(systemName: sfSymbol)
            }
            .padding()
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
                .stroke(backgroundColor)
            )
            .foregroundColor(foregroundColor)
            .cornerRadius(cornerRadius)
        }
    }
}
