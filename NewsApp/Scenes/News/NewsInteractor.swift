import UIKit

protocol NewsBusinessLogic {
    func getLatestNews(request: News.Latest.Request)
}

protocol NewsDataStore {
    // var name: String { get set }
}








enum CustomError: Error {
    case URLError
}

final class NewsInteractor: NewsDataStore {
    var presenter: NewsPresentationLogic?
    
    private var components: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spaceflightnewsapi.net"
        components.path = "/v4/articles"
        return components
    }()
    
}

extension NewsInteractor: NewsBusinessLogic {
    @MainActor
    func getLatestNews(request: News.Latest.Request) {
        Task(priority: .userInitiated) {
            do {
                let response = try await getNews()
                presenter?.presentLatestNews(response: response)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

private extension NewsInteractor {
    func getNews() async throws -> News.Latest.Response {
        guard let url = components.url else { throw  CustomError.URLError }
        let (data, _) = try await URLSession.shared.data(from: url)        
        let decodedData = try JSONDecoder().decode(News.Latest.Response.self, from: data)
        return decodedData
    }
}
