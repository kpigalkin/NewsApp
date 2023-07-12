import UIKit

protocol NewsBusinessLogic {
    func doSomething(request: News.Load.Request)
}

protocol NewsDataStore {
    // var name: String { get set }
}











final class NewsInteractor: NewsDataStore {
    var presenter: NewsPresentationLogic?
    
    private lazy var components: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spaceflightnewsapi.net"
        components.path = "/v4/articles"
        return components
    }()
    
    
    enum CustomError: Error {
        case URLError
    }
}

extension NewsInteractor: NewsBusinessLogic {
    @MainActor
    func doSomething(request: News.Load.Request) {
        Task(priority: .userInitiated) {
            do {
                let response = try await getNews()
                presenter?.presentSomething(response: response)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

private extension NewsInteractor {
    func getNews() async throws -> News.Load.Response {
        guard let url = components.url else { throw  CustomError.URLError }
        let (data, _) = try await URLSession.shared.data(from: url)        
        let decodedData = try JSONDecoder().decode(News.Load.Response.self, from: data)
        return decodedData
    }
}
