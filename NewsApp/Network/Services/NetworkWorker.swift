import Foundation

protocol NetworkWorkingLogic {
    func getBlogs() async throws -> HomeContentItems
    func getNews(offset: Int) async throws -> HomeContentItems
    func getBlogDetail(id: Int) async throws -> DetailModel
    func getNewsDetail(id: Int) async throws -> DetailModel
}

struct NetworkWorker: HTTPClient, NetworkWorkingLogic {
    func getNews(offset: Int) async throws -> HomeContentItems {
        return try await sendRequest(endpoint: SpaceFlightNewsEndpoint.news(offset: offset),
                                     responseModel: HomeContentItems.self)
    }
    
    func getBlogs() async throws -> HomeContentItems {
        return try await sendRequest(endpoint: SpaceFlightNewsEndpoint.blogs,
                                     responseModel: HomeContentItems.self)
    }
    
    func getBlogDetail(id: Int) async throws -> DetailModel {
        return try await sendRequest(endpoint: SpaceFlightNewsEndpoint.blogDetail(id: id),
                                     responseModel: DetailModel.self)
    }
    
    func getNewsDetail(id: Int) async throws -> DetailModel {
        return try await sendRequest(endpoint: SpaceFlightNewsEndpoint.newsDetail(id: id),
                                     responseModel: DetailModel.self)
    }
}
