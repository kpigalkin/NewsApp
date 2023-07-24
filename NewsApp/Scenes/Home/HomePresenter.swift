import UIKit

protocol HomePresentationLogic {
    func presentContent(response: HomeModels.DisplayContent.Response)
    func presentMoreNews(response: HomeModels.DisplayMoreNews.Response)
    func presentDetail(response: HomeModels.DisplayDetail.Response)
}

final class HomePresenter {
    weak var viewController: HomeDisplayLogic?
}

extension HomePresenter: HomePresentationLogic {

    func presentContent(response: HomeModels.DisplayContent.Response) {
        viewController?.displayContent(viewModel: .init(
            news: convertNews(response.news),
            blogs: convertBlogs(response.blogs),
            errorDescription: response.errorDescription
        ))
    }
    
    func presentMoreNews(response: HomeModels.DisplayMoreNews.Response) {
        viewController?.displayMoreNews(viewModel: .init(
            news: convertNews(response.news),
            errorDescription: response.errorDescription
        ))
    }
    
    func presentDetail(response: HomeModels.DisplayDetail.Response) {
        viewController?.displayDetail(viewModel: .init(
            errorDescription: response.errorDescription
        ))
    }
}

private extension HomePresenter {
    
    func convertNews(_ items: [News]?) -> [HomeCollectionItem] {
        guard let items else { return [] }
        return items.map {
            HomeCollectionItem(content: .news(configuration: .init(
                id: $0.id,
                imageURL: URL(string: $0.imageURL),
                title: $0.title,
                summary: $0.summary,
                date: DateFormatter().convertMultipleFormatDate(
                    formats: SpaceFlightNewsEndpoint.dateFormats,
                    from: $0.date,
                    toFormat: AppConstants.DateFormat.presentingFormat.rawValue
                )
            )))
        }
    }
    
    func convertBlogs(_ items: [Blog]?) -> [HomeCollectionItem] {
        guard let items else { return [] }
        return items.map {
            HomeCollectionItem(content: .blog(configuration: .init(
                id: $0.id,
                imageURL: URL(string: $0.imageURL),
                title: $0.title
            )))
        }
    }
}
