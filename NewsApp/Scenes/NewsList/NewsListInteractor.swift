import UIKit

protocol NewsListBusinessLogic {
    func fetchNews(request: NewsListModels.Show.Request)
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
    
    @MainActor func fetchNews(request: NewsListModels.Show.Request) {
        Task(priority: .userInitiated) {
            do {
                let response = try await self.request(
                    endPoint: SpaceFlightEndPoint.getNews(offset: request.offset),
                    model: NewsListModels.Show.Response.self
                )
                databaseService?.save(news: response.results)
                presenter?.presentNews(response: response)
            } catch {
                // FIXME: Catch errors
//                print(error.localizedDescription)
                
                guard let data = databaseService?.get(params: .all) else { return }
                let response = NewsListModels.Show.Response(results: data)
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

        guard let url = components.url else { throw  RequestError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}

