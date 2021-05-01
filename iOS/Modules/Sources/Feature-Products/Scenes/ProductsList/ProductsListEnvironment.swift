import ComposableArchitecture
import Core_RepositoryInterface
import LightInjection

public struct ProductsListEnvironment {
    
    @Dependency var productsListRepository: ProductRepositoryProtocol
    let mainQueue: AnySchedulerOf<DispatchQueue>
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    ) {
        self.mainQueue = mainQueue
    }
}
