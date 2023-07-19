import UIKit
import Kingfisher

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupKingFisher()
        
        return true
    }
}

private extension AppDelegate {
    func setupKingFisher() {
        // RAM 10mb
        ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 10
        // Disk 100 mb
        ImageCache.default.diskStorage.config.sizeLimit = 1024 * 1024 * 100
    }
}
