import ComposableArchitecture
import Core_RepositoryInterface
import LightInjection

public struct ProductsListEnvironment {
    
    @Dependency var productsListRepository: ProductRepositoryProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    ) {
        self.mainQueue = mainQueue
    }
}

#if DEBUG
extension ProductsListEnvironment {
    static let dummy: Self = .mocking()
    
    static func mocking(
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        productsListRepository: ProductRepositoryProtocol = ProductRepositoryDummy()
    ) -> Self {
        var instance: Self = .init(
            mainQueue: mainQueue
        )
        instance._productsListRepository = .resolved(productsListRepository)
        return instance
    }
}
#endif
