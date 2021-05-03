import SwiftUI

public struct RatingPicker: View {
    
    // MARK: - Properties
    
    private let image: ImageResource
    private let borderColor: Color
    private let maximumRating: Int
    private let onTapAction: (Int) -> Void
    @State public var rating: Int? // @FIXME: not working properly. fix this later.
    
    // MARK: - Initializers
    
    /// A horizontal row of buttons.
    /// Upon tapping a button, the other to the left of it are highlighted.
    /// - Parameters:
    ///   - image: The icon and color of all buttons.
    ///   - borderColor: The color of the thin border line around it.
    ///   - maximumRating: The number of buttons to be displayed.
    ///   - onTapAction: Action to be executed upon tapping one of the buttons. Returns the tapped index.
    public init(
        image: ImageResource = .init(
            sfSymbol: "star.fill",
            color: .yellow
        ),
        borderColor: Color = .secondary,
        maximumRating: Int = 5,
        onTapAction: @escaping (Int) -> Void
    ) {
        self.image = image
        self.borderColor = borderColor
        self.maximumRating = maximumRating
        self.onTapAction = onTapAction
    }
    
    // MARK: - UI
    
    public var body: some View {
        HStack {
            ForEach(0..<maximumRating) { index in
                Button(
                    action: { onTapAction(index) }
                ) {
                    Image(systemName: image.sfSymbol)
                }
                .frame(
                    width: DS.LayoutSize.medium.width,
                    height: DS.LayoutSize.medium.height,
                    alignment: .center
                )
                .foregroundColor(image.color)
                .opacity(
                    buttonOpacity(
                        rating: rating,
                        index: index
                    )
                )
                .padding(.horizontal, DS.Spacing.small)
            }
        }
        .overlay(
            RoundedRectangle(
                cornerRadius: DS.LayoutSize.medium.height/2,
                style: .continuous
            )
            .stroke(borderColor)
        )
    }
    
    
    // MARK: - Helper Methods
    
    private func buttonOpacity(rating: Int?, index: Int) -> Double {
        let minimum: Double = 0.25
        let maximum: Double = 1
        guard let rating = rating else { return minimum }
        return rating < index ? minimum : maximum
    }
}
