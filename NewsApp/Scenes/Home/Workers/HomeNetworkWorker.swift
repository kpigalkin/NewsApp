//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import Foundation
import Reachability

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
        guard connectionReachability else {
            throw RequestError.offline
        }
        let endpoint = SpaceFlightNewsEndpoint.news(offset: offset)
        let request = try makeRequest(with: endpoint)
        let data = try await execute(request: request)
        return try decode(NewsItems.self, from: data)
    }
    
    func getBlogs() async throws -> BlogItems {
        guard connectionReachability else {
            throw RequestError.offline
        }
        let endpoint = SpaceFlightNewsEndpoint.blogs
        let request = try makeRequest(with: endpoint)
        let data = try await execute(request: request)
        return try decode(BlogItems.self, from: data)
    }
    
    func getBlogDetail(id: Int) async throws -> Blog {
        guard connectionReachability else {
            throw RequestError.offline
        }
        let endpoint = SpaceFlightNewsEndpoint.blogDetail(id: id)
        let request = try makeRequest(with: endpoint)
        let data = try await execute(request: request)
        return try decode(Blog.self, from: data)
    }
    
    func getNewsDetail(id: Int) async throws -> News {
        guard connectionReachability else {
            throw RequestError.offline
        }
        let endpoint = SpaceFlightNewsEndpoint.newsDetail(id: id)
        let request = try makeRequest(with: endpoint)
        let data = try await execute(request: request)
        return try decode(News.self, from: data)
    }
}

    // MARK: - Decode & Request

private extension HomeNetworkWorker {
    var connectionReachability: Bool {
        guard let reachability = try? Reachability() else {
            return false
        }
        return reachability.connection != .unavailable
    }
    
    func makeRequest(with endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.name
        
        return request
    }
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(type.self, from: data) else {
            throw RequestError.decode
        }
        return decodedData
    }
}
