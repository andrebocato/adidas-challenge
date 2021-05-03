import ComposableArchitecture
import Core_RepositoryInterface
import Foundation
import LightInjection

struct ProductDetailEnvironment {

    var generateUUIDString: () -> String
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var currencyFormatter: CurrencyFormatterProtocol
    @Dependency var productRepository: ProductRepositoryProtocol
    @Dependency var reviewRepository: ReviewRepositoryProtocol

    init(
        generateUUIDString: @escaping () -> String = { UUID().uuidString },
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        currencyFormatter: CurrencyFormatterProtocol = DefaultCurrencyFormatter()
    ) {
        self.generateUUIDString = generateUUIDString
        self.mainQueue = mainQueue
        self.currencyFormatter = currencyFormatter
    }
}

#if DEBUG
extension ProductDetailEnvironment {
    static let dummy: Self = .mocking()
    
    static func mocking(
        generateUUIDString: @escaping () -> String = { "" },
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        currencyFormatter: CurrencyFormatterProtocol = CurrencyFormatterDummy(),
        productRepository: ProductRepositoryProtocol = ProductRepositoryDummy(),
        reviewRepository: ReviewRepositoryProtocol = ReviewRepositoryDummy()
    ) -> Self {
        var instance: Self = .init(
            generateUUIDString: generateUUIDString,
            mainQueue: mainQueue,
            currencyFormatter: currencyFormatter
        )
        instance._productRepository = .resolved(productRepository)
        instance._reviewRepository = .resolved(reviewRepository)
        return instance
    }
}
#endif
