import Core_RepositoryInterface

extension Product {
    init(from dto: ProductDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            description: dto.description,
            currency: dto.currency,
            price: dto.price,
            imageURL: dto.imageURL,
            reviews: dto.reviews.map { .init(from: $0) }
        )
    }
}

extension Review {
    init(from dto: ReviewDTO) {
        self.init(
            productId: dto.productId,
            locale: dto.locale,
            rating: dto.rating,
            text: dto.text
        )
    }
}
