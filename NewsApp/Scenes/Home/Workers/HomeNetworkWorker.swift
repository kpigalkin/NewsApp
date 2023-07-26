import Foundation

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
        let data = try await sendRequest(endpoint: SpaceFlightNewsEndpoint.news(offset: offset))
        return try decode(NewsItems.self, from: data)
    }
    
    func getBlogs() async throws -> BlogItems {
        let data = try await sendRequest(endpoint: SpaceFlightNewsEndpoint.blogs)
        return try decode(BlogItems.self, from: data)
    }
    
    func getBlogDetail(id: Int) async throws -> Blog {
        let data = try await sendRequest(endpoint: SpaceFlightNewsEndpoint.blogDetail(id: id))
        return try decode(Blog.self, from: data)
    }
    
    func getNewsDetail(id: Int) async throws -> News {
        let data = try await sendRequest(endpoint: SpaceFlightNewsEndpoint.newsDetail(id: id))
        return try decode(News.self, from: data)
    }
}

    // MARK: - Decode

private extension HomeNetworkWorker {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(type.self, from: data) else {
            throw RequestError.decode
        }
        return decodedData
    }
}
