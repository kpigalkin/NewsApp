import UIKit

protocol NewsPresentationLogic {
    func presentNews(response: NewsListModels.Show.Response)
}

final class NewsListPresenter {
    weak var viewController: NewsListDisplayLogic?
    
    private let toDateFormat = "MMM d, h:mm a"
}

extension NewsListPresenter: NewsPresentationLogic {
    func presentNews(response: NewsListModels.Show.Response) {
        let viewModel = NewsListModels.Show.ViewModel(newsItems:
            response.results.map {
            NewsListCollectionItem(content: .news(configuration: .init(
                            id: $0.id,
                            url: $0.url,
                            imageURL: URL(string: $0.imageURL),
                            title: $0.title,
                            summary: $0.summary,
                            date: DateFormatter().convertMultipleFormatDate(
                                formats: SpaceFlightEndPoint.dateFormats,
                                from: $0.date,
                                toFormat: toDateFormat
                            )
                        )))
            }
        )
        viewController?.displayNews(viewModel: viewModel)
    }
}

private extension NewsListPresenter {
    func handleStringDate(_ dateString: String) -> String {
        var date: Date?
        
        if dateString.contains(".") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            date = dateFormatter.date(from: dateString)
        } else {
            date = ISO8601DateFormatter().date(from: dateString)
        }
        
        guard let date else { return dateString }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}
