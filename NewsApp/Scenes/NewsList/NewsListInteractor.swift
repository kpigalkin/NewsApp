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
    
    private var components: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spaceflightnewsapi.net"
        components.path = "/v4/articles"
        return components
    }()
    
    var databaseService: DataBaseService?
    
    init(databaseService: DataBaseService?) {
        self.databaseService = databaseService
    }
}

extension NewsListInteractor: NewsListBusinessLogic {
    @MainActor
    func fetchNews(request: NewsListModels.Show.Request) {
        Task(priority: .userInitiated) {
            do {
                let response = try await getNews()
                databaseService?.save(news: response.results)
                presenter?.presentNews(response: response)
            } catch {
                // FIXME: Catch errors
                print(error.localizedDescription)
                
                guard let data = databaseService?.get(.all) else { return }
                let response = NewsListModels.Show.Response(results: data)
                presenter?.presentNews(response: response)
            }
        }
    }
    
    func selectNewsElement(request: NewsListModels.SelectElement.Request) {
        guard let selectedNewsItem = databaseService?.get(.id(identifier: request.index))?.first else {
            return
        }
        newsElement = selectedNewsItem
    }
}

private extension NewsListInteractor {
    func getNews() async throws -> NewsListModels.Show.Response {
        guard let url = components.url else { throw  CustomError.URLError }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(NewsListModels.Show.Response.self, from: data)
        return decodedData
    }
}

