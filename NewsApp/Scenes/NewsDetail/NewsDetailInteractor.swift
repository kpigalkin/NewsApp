import UIKit

protocol NewsDetailBusinessLogic {
    func fetchNewsDetail(request: NewsDetail.ShowElement.Request)
}

protocol NewsDetailDataStore {
    var newsElement: NewsListItem? { get set }
}

final class NewsDetailInteractor: NewsDetailDataStore {
    var presenter: NewsDetailPresentationLogic?
    var newsElement: NewsListItem?
}

extension NewsDetailInteractor: NewsDetailBusinessLogic {
    func fetchNewsDetail(request: NewsDetail.ShowElement.Request) {
        guard let newsElement else { return }
        let response = NewsDetail.ShowElement.Response(element: newsElement)
        presenter?.presentNewsDetail(response: response)
    }
}
