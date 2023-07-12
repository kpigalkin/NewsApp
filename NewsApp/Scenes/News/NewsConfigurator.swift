import Foundation

struct NewsConfigurator {
    static func configure() -> NewsViewController {
        let viewController = NewsViewController()
        let interactor = NewsInteractor()
        let presenter = NewsPresenter()
        let router = NewsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
