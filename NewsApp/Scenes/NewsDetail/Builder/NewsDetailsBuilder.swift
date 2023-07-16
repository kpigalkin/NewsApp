import UIKit

protocol NewsDetailBuildable {
    func build() -> UIViewController
}

struct NewsDetailsBuilder: NewsDetailBuildable {
    func build() -> UIViewController {
        let viewController = NewsDetailViewController()
        let interactor = NewsDetailInteractor()
        let presenter = NewsDetailPresenter()
        let router = NewsDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
