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
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
