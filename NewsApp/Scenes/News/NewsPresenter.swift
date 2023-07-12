import UIKit

protocol NewsPresentationLogic {
    func presentSomething(response: News.Load.Response)
}

final class NewsPresenter: NewsPresentationLogic {
    weak var viewController: NewsDisplayLogic?
    
    func presentSomething(response: News.Load.Response) {
        let viewModel = News.Load.ViewModel(results:
            response.results.map {
                NewsCollectionItem(content: .news(configuration: .init(
                            id: $0.id,
                            title: $0.title,
                            url: $0.url,
                            imageURL: $0.url,
                            summary: $0.summary,
                            date: $0.publishedAt
                        )))
            }
        )
        viewController?.displayNews(viewModel: viewModel)
    }
}
