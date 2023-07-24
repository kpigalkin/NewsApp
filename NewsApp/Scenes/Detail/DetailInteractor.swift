import UIKit

protocol DetailBusinessLogic {
    func fetchDetail(request: Detail.Display.Request)
}

protocol DetailDataStore {
    var detailContent: DetailContent? { get set }
}

final class DetailInteractor: DetailDataStore {
    var presenter: DetailPresentationLogic?
    var detailContent: DetailContent?
}

extension DetailInteractor: DetailBusinessLogic {
    func fetchDetail(request: Detail.Display.Request) {
        guard let detailContent else { return }
        presenter?.presentDetail(response: .init(content: detailContent))
    }
}
