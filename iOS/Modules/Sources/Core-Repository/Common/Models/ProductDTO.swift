import Foundation

struct ProductDTO: Decodable {
    let id: String
    let name: String
    let description: String
    let currency: String
    let price: Double
    let imageURL: String
    let reviews: [ReviewDTO]
}

// MARK: - Coding Keys

extension ProductDTO {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case currency
        case price
        case imageURL = "imgUrl"
        case reviews
    }
}
