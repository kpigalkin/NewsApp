import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var newsListBuilder: NewsListBuildable!
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        newsListBuilder = NewsListBuilder()
        window = UIWindow(windowScene: scene)
        window?.rootViewController = newsListBuilder.build()
        window?.makeKeyAndVisible()
    }
}
