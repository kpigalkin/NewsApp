
    // MARK: - Protocols

protocol HomeNetworkWorkingLogic {
    func getBlogs() async throws -> BlogItems
    func getNews(offset: Int) async throws -> NewsItems
    func getBlogDetail(id: Int) async throws -> Blog
    func getNewsDetail(id: Int) async throws -> News
}

    // MARK: - HomeNetworkWorker

final class HomeNetworkWorker {}

    // MARK: - HomeNetworkWorkingLogic & HTTPClient

extension HomeNetworkWorker: HomeNetworkWorkingLogic, HTTPClient {
    func getNews(offset: Int) async throws -> NewsItems {
        return try await sendRequest(endpoint: SpaceFlightNewsEndpoint.news(offset: offset),
                                     responseModel: NewsItems.self)
    }
    
    func getBlogs() async throws -> BlogItems {
        return try await sendRequest(endpoint: SpaceFlightNewsEndpoint.blogs,
                                     responseModel: BlogItems.self)
    }
    
    func getBlogDetail(id: Int) async throws -> Blog {
        return try await sendRequest(endpoint: SpaceFlightNewsEndpoint.blogDetail(id: id),
                                     responseModel: Blog.self)
    }
    
    func getNewsDetail(id: Int) async throws -> News {
        return try await sendRequest(endpoint: SpaceFlightNewsEndpoint.newsDetail(id: id),
                                     responseModel: News.self)
    }
}
