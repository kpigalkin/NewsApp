import UIKit

protocol HomeRoutingLogic {
    func routeToDetail()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

final class HomeRouter: HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
}

extension HomeRouter: HomeRoutingLogic {
    func routeToDetail() {        
        guard let destinationVC = DetailBuilder().build() as? DetailViewController,
              var detailsDataStore = destinationVC.router?.dataStore,
              let viewController,
              let dataStore
        else { return }
              
        passDataToDetail(source: dataStore, destination: &detailsDataStore)
        navigateToDetail(source: viewController, destination: destinationVC)
    }
}

private extension HomeRouter {
    func navigateToDetail(source: HomeViewController, destination: DetailViewController) {
        destination.sheetPresentationController?.detents = [.medium()]
        source.present(destination, animated: true)
    }

    func passDataToDetail(source: HomeDataStore, destination: inout DetailDataStore) {
        destination.itemDetail = source.itemDetail
    }
}
