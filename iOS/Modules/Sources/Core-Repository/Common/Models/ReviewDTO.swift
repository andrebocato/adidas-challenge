import Foundation

struct ReviewDTO: Decodable {
    let productId: String
    let locale: String?
    let rating: Int
    let text: String
}
