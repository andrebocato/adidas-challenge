import ComposableArchitecture
import Core_RepositoryInterface
import Foundation
import LightInjection

struct ProductDetailEnvironment {
    
    var generateUUIDString: () -> String
    @Dependency var productRepository: ProductRepositoryProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var currencyFormatter: CurrencyFormatterProtocol

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
        productRepository: ProductRepositoryProtocol = ProductRepositoryDummy(),
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        currencyFormatter: CurrencyFormatterProtocol = CurrencyFormatterDummy()
    ) -> Self {
        var instance: Self = .init(
            generateUUIDString: generateUUIDString,
            mainQueue: mainQueue,
            currencyFormatter: currencyFormatter
        )
        instance._productRepository = .resolved(productRepository)
        return instance
    }
}
#endif
