import Foundation

struct ProductDetailEnvironment {
    
    var generateUUIDString: () -> String
    
    init(
        generateUUIDString: @escaping () -> String = { UUID().uuidString }
    ) {
        self.generateUUIDString = generateUUIDString
    }
}

#if DEBUG
extension ProductDetailEnvironment {
    static let dummy: Self = .mocking()
    
    static func mocking(
        generateUUIDString: @escaping () -> String = { "" }
    ) -> Self {
        .init(generateUUIDString: generateUUIDString)
    }
}
#endif
