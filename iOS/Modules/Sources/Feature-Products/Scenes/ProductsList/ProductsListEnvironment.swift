import ComposableArchitecture
import Core_RepositoryInterface
import LightInjection

public struct ProductsListEnvironment {
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var currencyFormatter: CurrencyFormatterProtocol
    @Dependency var productsListRepository: ProductRepositoryProtocol
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        currencyFormatter: CurrencyFormatterProtocol = DefaultCurrencyFormatter()
    ) {
        self.mainQueue = mainQueue
        self.currencyFormatter = currencyFormatter
    }
}

#if DEBUG
extension ProductsListEnvironment {
    static let dummy: Self = .mocking()
    
    static func mocking(
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        currencyFormatter: CurrencyFormatterProtocol = CurrencyFormatterDummy(),
        productsListRepository: ProductRepositoryProtocol = ProductRepositoryDummy()
    ) -> Self {
        var instance: Self = .init(
            mainQueue: mainQueue,
            currencyFormatter: currencyFormatter
        )
        instance._productsListRepository = .resolved(productsListRepository)
        return instance
    }
}
#endif
