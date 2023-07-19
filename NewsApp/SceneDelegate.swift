import UIKit
import RealmSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var newsListBuilder: HomeBuildable!
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        newsListBuilder = HomeBuilder()
        window = UIWindow(windowScene: scene)
        window?.rootViewController = newsListBuilder.build()
        window?.makeKeyAndVisible()
    }
}
