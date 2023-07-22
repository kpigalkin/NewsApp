import Foundation
import UIKit

protocol HomeBuildable {
    func build() -> UIViewController
}

struct HomeBuilder: HomeBuildable {
    func build() -> UIViewController {
        let viewController = HomeViewController()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        let networkWorker = NetworkWorker()
        let storageManager = StorageManager()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.storageManager = storageManager
        interactor.networkManager = networkWorker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
