import Feature_Products
import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupRootViewController(windowScene: windowScene)
    }
}

// MARK: - RootView Configuration

extension SceneDelegate {
    private func setupRootViewController(windowScene: UIWindowScene) {
        let frame = windowScene.coordinateSpace.bounds
        let rootView = ProductsListView(
            store: .init(
                initialState: .init(),
                reducer: productsListReducer,
                environment: ProductsListEnvironment()
            )
        )
        let rootViewController = UIHostingController(rootView: rootView)
        
        window = .init(frame: frame)
        window?.windowScene = windowScene
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

}
