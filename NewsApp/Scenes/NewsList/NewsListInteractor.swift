import UIKit

protocol NewsListBusinessLogic {
    func fetchNews(request: NewsListModels.ShowNews.Request)
    func selectNewsElement(request: NewsListModels.SelectElement.Request)
}

protocol NewsListDataStore {
     var newsElement: NewsModel? { get set }
}

final class NewsListInteractor: NewsListDataStore {
    private var storage = [NewsModel]()
    
    var presenter: NewsPresentationLogic?
    var networkWorker: NetworkWorkingLogic?
    var databaseService: DataBaseService?
    var newsElement: NewsModel?
}

extension NewsListInteractor: NewsListBusinessLogic {
    
    func fetchNews(request: NewsListModels.ShowNews.Request) {
        Task(priority: .userInitiated) { @MainActor in
            do {
                guard let news = try await networkWorker?.request(
                    endPoint: SNAPIEndPoint.getNews(offset: request.offset),
                    model: NewsListModel.self
                ) else { return }
                databaseService?.save(news: news.results)
                let response = NewsListModels.ShowNews.Response(news: news, error: nil)
                presenter?.presentNews(response: response)
                
            } catch RequestError.offline {

                guard let data = databaseService?.get(params: .all) else { return }
                let news = NewsListModel(results: data)
                let response = NewsListModels.ShowNews.Response(news: news, error: .offline)
                presenter?.presentNews(response: response)
            }
        }
    }
    
    func selectNewsElement(request: NewsListModels.SelectElement.Request) {
        guard let selectedNewsItem = databaseService?.get(params: .id(identifier: request.index))?.first else {
            return
        }
        newsElement = selectedNewsItem
    }
}
