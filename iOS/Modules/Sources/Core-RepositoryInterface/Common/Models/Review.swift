import Foundation

public struct Review: Equatable {
    public let productId: String
    public let locale: String
    public let rating: Int
    public let text: String
    
    public init(
        productId: String,
        locale: String,
        rating: Int,
        text: String
    ) {
        self.productId = productId
        self.locale = locale
        self.rating = rating
        self.text = text
    }
}
