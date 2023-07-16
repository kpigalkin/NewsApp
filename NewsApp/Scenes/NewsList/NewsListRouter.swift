import UIKit

protocol NewsListRoutingLogic {
    func routeToNewsDetail()
}

protocol NewsListDataPassing {
    var dataStore: NewsListDataStore? { get }
}

final class NewsListRouter: NewsListDataPassing {
    weak var viewController: NewsListViewController?
    var dataStore: NewsListDataStore?
}

extension NewsListRouter: NewsListRoutingLogic {
    func routeToNewsDetail() {
        guard let destinationVC = NewsDetailsBuilder().build() as? NewsDetailViewController,
              var detailsDataStore = destinationVC.router?.dataStore,
              let viewController,
              let dataStore
        else { return }
              
        passDataToNewsDetail(source: dataStore, destination: &detailsDataStore)
        navigateToNewsDetail(source: viewController, destination: destinationVC)
    }
}

private extension NewsListRouter {
    func navigateToNewsDetail(source: NewsListViewController, destination: NewsDetailViewController) {
        destination.sheetPresentationController?.detents = [.medium()]
        source.present(destination, animated: true)
    }

    func passDataToNewsDetail(source: NewsListDataStore, destination: inout NewsDetailDataStore) {
        destination.newsElement = source.newsElement
    }
}
