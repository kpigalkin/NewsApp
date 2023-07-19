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
        let storageWorker = StorageWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.storageWorker = storageWorker
        interactor.networkWorker = networkWorker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
