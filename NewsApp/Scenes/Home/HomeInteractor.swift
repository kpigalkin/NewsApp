import UIKit

protocol HomeBusinessLogic {
    func fetchNews(request: HomeModels.DisplayNews.Request)
    func fetchBlogs(request: HomeModels.DisplayBlogs.Request)
    func fetchSelectedNews(request: HomeModels.DisplayNewsDetail.Request)
    func fetchSelectedBlog(request: HomeModels.DisplayBlogDetail.Request)
}

protocol HomeDataStore {
     var itemDetail: DetailModel? { get set }
}

final class HomeInteractor: HomeDataStore {
    var networkWorker: NetworkWorkingLogic?
    var storageWorker: StorageWorkingLogic?
    var presenter: HomePresentationLogic?

    var itemDetail: DetailModel?
}

extension HomeInteractor: HomeBusinessLogic {
    func fetchNews(request: HomeModels.DisplayNews.Request) {
        Task(priority: .userInitiated) { @MainActor in
            do {
                guard let news = try await networkWorker?.request(
                    endPoint: SNAPIEndPoint.getNews(offset: request.offset),
                    model: HomeContentModel.self
                ) else { return }
                
                storageWorker?.saveNews(news.results)
                
                let response = HomeModels.DisplayNews.Response(news: news, error: nil)
                presenter?.presentNews(response: response)
                
            } catch RequestError.offline {
                guard let data = storageWorker?.getAllNews() else { return }
                
                let news = HomeContentModel(results: data)
                let response = HomeModels.DisplayNews.Response(news: news, error: .offline)
                
                presenter?.presentNews(response: response)
            }
        }
    }
    
    func fetchBlogs(request: HomeModels.DisplayBlogs.Request) {
        Task(priority: .userInitiated) { @MainActor in
            do {
                guard let blogs = try await networkWorker?.request(
                    endPoint: SNAPIEndPoint.getBlogs,
                    model: HomeContentModel.self
                ) else { return }
                
                storageWorker?.saveBlogs(blogs.results)
                
                let response = HomeModels.DisplayBlogs.Response(blogs: blogs, error: nil)
                presenter?.presentBlogs(response: response)
                
            } catch RequestError.offline {
                guard let data = storageWorker?.getAllNews() else { return }

                let blogs = HomeContentModel(results: data)
                let response = HomeModels.DisplayBlogs.Response(blogs: blogs, error: .offline)

                presenter?.presentBlogs(response: response)
            }
        }
    }
    
    func fetchSelectedNews(request: HomeModels.DisplayNewsDetail.Request) {
        itemDetail = storageWorker?.getNewsDetail(with: request.id)
    }
    
    func fetchSelectedBlog(request: HomeModels.DisplayBlogDetail.Request) {
        itemDetail = storageWorker?.getBlogDetail(with: request.id)
    }
}
