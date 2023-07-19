import UIKit

protocol DetailBuildable {
    func build() -> UIViewController
}

struct DetailBuilder: DetailBuildable {
    func build() -> UIViewController {
        let viewController = DetailViewController()
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
