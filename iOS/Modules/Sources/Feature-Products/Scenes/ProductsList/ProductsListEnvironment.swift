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
