import UIKit

protocol HomePresentationLogic {
    func presentContent(response: HomeModels.DisplayContent.Response)
    func presentMoreNews(response: HomeModels.DisplayMoreNews.Response)
    func presentDetail(response: HomeModels.DisplayDetail.Response)
}

final class HomePresenter {
    weak var viewController: HomeDisplayLogic?
    
    private let dateFormat = "MMM d, h:mm a"
}

extension HomePresenter: HomePresentationLogic {
    
    func presentContent(response: HomeModels.DisplayContent.Response) {
        let viewModel = HomeModels.DisplayContent.ViewModel(
            news: convertNews(response.news.results),
            blogs: convertBlogs(response.blogs.results),
            success: response.error == nil,
            errorTitle: response.error?.title,
            errorMessage: response.error?.message
        )
        viewController?.displayContent(viewModel: viewModel)
    }
    
    func presentMoreNews(response: HomeModels.DisplayMoreNews.Response) {
        let viewModel = HomeModels.DisplayMoreNews.ViewModel(
            news: convertNews(response.news.results),
            success: response.error == nil,
            errorTitle: response.error?.title,
            errorMessage: response.error?.message
        )
        viewController?.displayMoreNews(viewModel: viewModel)
    }
    
    func presentDetail(response: HomeModels.DisplayDetail.Response) {
        let viewModel = HomeModels.DisplayDetail.ViewModel(
            success: response.error == nil,
            errorTitle: response.error?.localizedDescription,
            errorMessage: response.error.debugDescription
        )
        viewController?.displayDetail(viewModel: viewModel)
    }
}

private extension HomePresenter {
    func convertNews(_ items: [DetailModel]) -> [HomeCollectionItem] {
        items.map {
            HomeCollectionItem(content: .news(configuration: .init(
                id: $0.id,
                imageURL: URL(string: $0.imageURL),
                title: $0.title,
                summary: $0.summary,
                date: DateFormatter().convertMultipleFormatDate(
                    formats: SNAPIEndPoint.dateFormats,
                    from: $0.date,
                    toFormat: dateFormat
                )
            )))
        }
    }
    
    func convertBlogs(_ items: [DetailModel]) -> [HomeCollectionItem] {
        items.map {
            HomeCollectionItem(content: .blog(configuration: .init(
                id: $0.id,
                imageURL: URL(string: $0.imageURL),
                title: $0.title
            )))
        }
    }
}
