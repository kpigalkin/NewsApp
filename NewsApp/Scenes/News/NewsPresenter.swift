import UIKit

protocol NewsPresentationLogic {
    func presentLatestNews(response: News.Latest.Response)
}

final class NewsPresenter: NewsPresentationLogic {
    weak var viewController: NewsDisplayLogic?
    
    func presentLatestNews(response: News.Latest.Response) {
        let viewModel = News.Latest.ViewModel(newsItems:
            response.results.map {
            NewsCollectionItem(content: .news(configuration: .init(
                            id: $0.id,
                            url: $0.url,
                            imageURL: URL(string: $0.imageURL),
                            title: $0.title,
                            summary: $0.summary,
                            date: $0.publishedAt
                        )))
            }
        )
        viewController?.displayNews(viewModel: viewModel)
    }
}
