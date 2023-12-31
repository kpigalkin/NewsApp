//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit

    // MARK: - Protocols

protocol HomeRoutingLogic {
    func routeToDetail()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

    // MARK: - HomeRouter

final class HomeRouter: HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
}

    // MARK: - HomeRoutingLogic

extension HomeRouter: HomeRoutingLogic {
    func routeToDetail() {        
        guard
            let destinationVC = DetailSceneConfigurator.configure() as? DetailViewController,
            var detailsDataStore = destinationVC.router?.dataStore,
            let viewController,
            let dataStore
        else {
            return
        }
              
        passDataToDetail(source: dataStore, destination: &detailsDataStore)
        navigateToDetail(source: viewController, destination: destinationVC)
    }
}

    // MARK: - Navigation & data passing

private extension HomeRouter {
    func navigateToDetail(source: HomeViewController, destination: DetailViewController) {
        source.present(destination, animated: true)
    }

    func passDataToDetail(source: HomeDataStore, destination: inout DetailDataStore) {
        destination.detailContent = source.detailContent
    }
}
