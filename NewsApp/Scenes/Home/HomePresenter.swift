import UIKit

protocol HomePresentationLogic {
    func presentNews(response: HomeModels.DisplayNews.Response)
    func presentBlogs(response: HomeModels.DisplayBlogs.Response)
}

final class HomePresenter {
    weak var viewController: HomeDisplayLogic?
    
    private let dateFormat = "MMM d, h:mm a"
}

extension HomePresenter: HomePresentationLogic {
    func presentNews(response: HomeModels.DisplayNews.Response) {
        let news = response.news.results
            .map {
                HomeCollectionItem(content: .news(
                    configuration: .init(
                        id: $0.id,
                        imageURL: URL(string: $0.imageURL),
                        title: $0.title,
                        summary: $0.summary,
                        date: DateFormatter().convertMultipleFormatDate(
                            formats: SNAPIEndPoint.dateFormats,
                            from: $0.date,
                            toFormat: dateFormat
                        )
                    )
                ))
            }
        
        let viewModel = HomeModels.DisplayNews.ViewModel(
            news: news,
            success: response.error == nil,
            errorTitle: response.error?.title,
            errorMessage: response.error?.message
        )
        viewController?.displayNews(viewModel: viewModel)
    }
    
    func presentBlogs(response: HomeModels.DisplayBlogs.Response) {
        let blogs = response.blogs.results
            .map {
                HomeCollectionItem(content: .blog(
                    configuration: .init(
                        id: $0.id,
                        imageURL: URL(string: $0.imageURL),
                        title: $0.title
                    )
                ))
            }
        
        let viewModel = HomeModels.DisplayBlogs.ViewModel(
            blogs: blogs,
            success: response.error == nil,
            errorTitle: response.error?.title,
            errorMessage: response.error?.message
        )
        viewController?.displayBlogs(viewModel: viewModel)
    }
}
