import SwiftUI

public struct ImageResource {
    /// This is related to `systemName`, please check SFSymbols
    public let sfSymbol: String
    public let color: Color
    
    public init(
        sfSymbol: String,
        color: Color = .secondary
    ) {
        self.sfSymbol = sfSymbol
        self.color = color
    }
}
