import Foundation
import UIKit

protocol NewsListBuildable {
    func build() -> UIViewController
}

struct NewsListBuilder: NewsListBuildable {
    func build() -> UIViewController {
        let viewController = NewsListViewController()
        let interactor = NewsListInteractor()
        let presenter = NewsListPresenter()
        let router = NewsListRouter()
        let networkWorker = NetworkWorker()
        let databaseService = RealmService()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.databaseService = databaseService
        interactor.networkWorker = networkWorker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
