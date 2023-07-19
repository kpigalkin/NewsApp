import UIKit

protocol DetailRoutingLogic {}

protocol DetailDataPassing {
    var dataStore: DetailDataStore? { get }
}

final class DetailsRouter: DetailRoutingLogic, DetailDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore?
}
