import UIKit

    // MARK: - Protocols

protocol DetailRoutingLogic {}

protocol DetailDataPassing {
    var dataStore: DetailDataStore? { get }
}

    // MARK: - DetailsRouter

final class DetailsRouter: DetailRoutingLogic, DetailDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore?
}
