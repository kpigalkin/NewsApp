import UIKit

protocol NewsPresentationLogic {
    func presentNews(response: NewsListModels.ShowNews.Response)
}

final class NewsListPresenter {
    weak var viewController: NewsListDisplayLogic?
    
    private let toDateFormat = "MMM d, h:mm a"
}

extension NewsListPresenter: NewsPresentationLogic {
    func presentNews(response: NewsListModels.ShowNews.Response) {
        let news = response.news.results.map {
            NewsListCollectionItem(content: .news(configuration: .init(
                id: $0.id,
                url: $0.url,
                imageURL: URL(string: $0.imageURL),
                title: $0.title,
                summary: $0.summary,
                date: DateFormatter().convertMultipleFormatDate(
                    formats: SNAPIEndPoint.dateFormats,
                    from: $0.date,
                    toFormat: toDateFormat
                )
            )))
        }
        
        let viewModel = NewsListModels.ShowNews.ViewModel(
            news: news,
            success: response.error == nil,
            errorTitle: response.error?.title,
            errorMessage: response.error?.message
        )
        viewController?.displayNews(viewModel: viewModel)
    }
}
