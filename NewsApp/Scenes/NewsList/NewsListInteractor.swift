import UIKit

protocol NewsListBusinessLogic {
    func fetchNews(request: NewsListModels.Show.Request)
    func selectNewsElement(request: NewsListModels.SelectElement.Request)
}

protocol NewsListDataStore {
     var newsElement: NewsListItem? { get set }
}

final class NewsListInteractor: NewsListDataStore {
    private var storage = [NewsListItem]()
    var presenter: NewsPresentationLogic?
    var newsElement: NewsListItem?
    
    private var components: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spaceflightnewsapi.net"
        components.path = "/v4/articles"
        return components
    }()
}

extension NewsListInteractor: NewsListBusinessLogic {
    @MainActor
    func fetchNews(request: NewsListModels.Show.Request) {
        Task(priority: .userInitiated) {
            do {
                let response = try await getNews()
                storage = response.results
                presenter?.presentNews(response: response)
            } catch {
                // FIXME: Catch errors
                print(error.localizedDescription)
            }
        }
    }
    
    func selectNewsElement(request: NewsListModels.SelectElement.Request) {
        guard storage.indices.contains(request.index) else { return }
        newsElement = storage[request.index]
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

