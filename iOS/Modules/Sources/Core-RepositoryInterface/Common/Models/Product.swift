import Foundation

public struct Product: Equatable {
    public let id: String
    public let name: String
    public let description: String
    public let currency: String
    public let price: Double
    public let imageURL: String
    public let reviews: [Review]
    
    public init(
        id: String,
        name: String,
        description: String,
        currency: String,
        price: Double,
        imageURL: String,
        reviews: [Review]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.currency = currency
        self.price = price
        self.imageURL = imageURL
        self.reviews = reviews
    }
}
