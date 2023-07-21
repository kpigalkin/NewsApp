import UIKit

protocol HomeBusinessLogic {
    func fetchContent(request: HomeModels.DisplayContent.Request)
    func fetchMoreNews(request: HomeModels.DisplayMoreNews.Request)
    func fetchSelectedDetail(request: HomeModels.DisplayDetail.Request)
}

protocol HomeDataStore {
     var itemDetail: DetailModel? { get set }
}

final class HomeInteractor: HomeDataStore {
    var networkManager: NetworkManagingLogic?
    var storageManager: StorageManagingLogic?
    var presenter: HomePresentationLogic?

    var itemDetail: DetailModel?
}

extension HomeInteractor: HomeBusinessLogic {
    
    func fetchContent(request: HomeModels.DisplayContent.Request) {
        Task(priority: .userInitiated) { @MainActor in
            do {
                async let newsRequest = networkManager?.request(
                    endPoint: SNAPIEndPoint.getLatestNews,
                    model: HomeContentItems.self
                )
                async let blogsRequest  = networkManager?.request(
                    endPoint: SNAPIEndPoint.getLatestBlogs,
                    model: HomeContentItems.self
                )
                guard let news = try await newsRequest,
                      let blogs = try await blogsRequest
                else { return }
                
                let response = HomeModels.DisplayContent.Response(blogs: blogs, news: news, error: nil)
                presenter?.presentContent(response: response)
                
                storageManager?.saveBlogs(blogs.results)
                storageManager?.saveNews(news.results)
                
            } catch RequestError.offline {
                guard let dbNews = storageManager?.getNews(),
                      let dbBlogs = storageManager?.getBlogs()
                else { return }
                
                let news = HomeContentItems(results: dbNews)
                let blogs = HomeContentItems(results: dbBlogs)
                let response = HomeModels.DisplayContent.Response(blogs: blogs, news: news, error: .offline)
                
                presenter?.presentContent(response: response)
            }
        }
    }
    
    func fetchMoreNews(request: HomeModels.DisplayMoreNews.Request) {
        Task(priority: .userInitiated) { @MainActor in
            guard let news = try await networkManager?.request(
                endPoint: SNAPIEndPoint.getNews(offset: request.offset),
                model: HomeContentItems.self
            ) else { return }
                        
            let response = HomeModels.DisplayMoreNews.Response(news: news, error: nil)
            presenter?.presentMoreNews(response: response)
            
            storageManager?.saveNews(news.results)
        }
    }
    
    func fetchSelectedDetail(request: HomeModels.DisplayDetail.Request) {
        switch request.forSection {
        case .blog:
            
            do {
                itemDetail = try storageManager?.getBlogDetail(with: request.id)
                presenter?.presentDetail(response: .init(error: nil))
            } catch StorageError.notFound {
                
                Task(priority: .userInitiated) { @MainActor in
                    let endPoint = SNAPIEndPoint.getBlogDetail(id: request.id)
                    itemDetail = try await networkManager?.request(endPoint: endPoint, model: DetailModel.self)
                    presenter?.presentDetail(response: .init(error: nil))
                }
                
            } catch {
                presenter?.presentDetail(response: .init(error: error))
            }
            
        case .news:
            
            do {
                itemDetail = try storageManager?.getNewsDetail(with: request.id)
                presenter?.presentDetail(response: .init(error: nil))
            } catch StorageError.notFound {
                
                Task(priority: .userInitiated) { @MainActor in
                    let endPoint = SNAPIEndPoint.getNewsDetail(id: request.id)
                    itemDetail = try await networkManager?.request(endPoint: endPoint, model: DetailModel.self)
                    presenter?.presentDetail(response: .init(error: nil))
                }
                
            } catch {
                presenter?.presentDetail(response: .init(error: error))
            }
            
        }
    }
}
