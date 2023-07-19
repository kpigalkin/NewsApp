import UIKit

protocol DetailBusinessLogic {
    func fetchDetail(request: Detail.Display.Request)
}

protocol DetailDataStore {
    var itemDetail: DetailModel? { get set }
}

final class DetailInteractor: DetailDataStore {
    var presenter: DetailPresentationLogic?
    var itemDetail: DetailModel?
}

extension DetailInteractor: DetailBusinessLogic {
    func fetchDetail(request: Detail.Display.Request) {
        guard let itemDetail else { return }
        let response = Detail.Display.Response(element: itemDetail)
        presenter?.presentDetail(response: response)
    }
}
