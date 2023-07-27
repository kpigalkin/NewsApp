import UIKit

struct DetailSceneConfigurator: SceneConfigurator {
    
    static func configure() -> UIViewController {
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
