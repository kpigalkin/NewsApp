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
    var newsElement: NewsModel?
    var databaseService: DataBaseService?
    
    init(databaseService: DataBaseService?) {
        self.databaseService = databaseService
    }
}

extension NewsListInteractor: NewsListBusinessLogic {
    
    func fetchNews(request: NewsListModels.ShowNews.Request) {
        Task(priority: .userInitiated) { @MainActor in
            do {
                let news = try await self.request(
                    endPoint: SNAPIEndPoint.getNews(offset: request.offset),
                    model: NewsListModel.self
                )
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

    // FIXME: Should be Worker or NetworkService

private extension NewsListInteractor {
    func request<T: Decodable>(endPoint: EndPoint, model: T.Type) async throws -> T {
        var components = URLComponents()
        components.scheme = endPoint.scheme
        components.host = endPoint.host
        components.path = endPoint.path
        components.queryItems = endPoint.parameters

        guard let url = components.url else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    throw RequestError.decode
                }
                return decodedData
            default:
                throw RequestError.unknown
            }
        } catch URLError.Code.notConnectedToInternet {
            throw RequestError.offline
        }
    }
}

