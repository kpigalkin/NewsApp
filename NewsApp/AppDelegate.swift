//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit
import Kingfisher

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupCache()
        return true
    }
}

private extension AppDelegate {
    func setupCache() {
        ImageCache.default.memoryStorage.config.totalCostLimit = .memoryLimit
        ImageCache.default.diskStorage.config.sizeLimit = .diskLimit
    }
}
