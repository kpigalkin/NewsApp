import UIKit

struct HomeSceneConfigurator: SceneConfigurator {
    
    static func configure() -> UIViewController {
        let viewController = HomeViewController()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        let networkWorker = HomeNetworkWorker()
        let storageWorker = StorageWorker()
        let storageService = RealmService.shared
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.storageWorker = storageWorker
        interactor.networkWorker = networkWorker
        storageWorker.storageService = storageService
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
