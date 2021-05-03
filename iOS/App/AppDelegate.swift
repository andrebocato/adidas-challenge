import Core_Networking
import Core_NetworkingInterface
import Core_Repository
import Core_RepositoryInterface
import LightInjection
import UIKit

// MARK: - App Environment

struct AppEnvironment {
    let httpDispatcher: HTTPRequestDispatcherProtocol
}
extension AppEnvironment {
    static let live: Self = .init(
        httpDispatcher: HTTPRequestDispatcher()
    )
}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Dependencies
    
    private(set) var appEnvironment: AppEnvironment!
    
    // MARK: - UIApplicationDelegate Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appEnvironment = .live
        registerDependencies(using: appEnvironment)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

// MARK: - Dependencies Registration

extension AppDelegate {
    
    private func registerDependencies(using appEnvironment: AppEnvironment) {
        LightInjection.registerLazyDependency(
            factory: {
                ProductRepository.init(
                    dispatcher: appEnvironment.httpDispatcher
                )
            },
            forMetaType: ProductRepositoryProtocol.self
        )
        
        LightInjection.registerLazyDependency(
            factory: {
                ReviewRepository.init(
                    dispatcher: appEnvironment.httpDispatcher
                )
            },
            forMetaType: ReviewRepositoryProtocol.self
        )
    }
}
