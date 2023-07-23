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
    var networkManager: NetworkWorkingLogic?
    var storageManager: StorageManagingLogic?
    var presenter: HomePresentationLogic?
    
    var itemDetail: DetailModel?
}

extension HomeInteractor: HomeBusinessLogic {
    @MainActor
    func fetchContent(request: HomeModels.DisplayContent.Request) {
        Task {
            do {
                async let newsRequest = networkManager?.getNews(offset: .zero)
                async let blogRequest = networkManager?.getBlogs()
                
                guard let news = try await newsRequest,
                      let blogs = try await blogRequest else { return }

                storageManager?.saveBlogs(blogs.results)
                storageManager?.saveNews(news.results)

                presenter?.presentContent(response: .init(
                    blogs: blogs,
                    news: news,
                    errorDescription: nil
                ))

            } catch let error as RequestError {

                guard let dbNews = storageManager?.getNews(),
                      let dbBlogs = storageManager?.getBlogs() else { return }
                
                presenter?.presentContent(response: .init(
                    blogs: HomeContentItems(results: dbBlogs),
                    news: HomeContentItems(results: dbNews),
                    errorDescription: error.description
                ))
                
            } catch let error as StorageError {
                
                presenter?.presentContent(response: .init(
                    blogs: nil,
                    news: nil,
                    errorDescription: error.description
                ))
            }
        }
    }
    
    @MainActor
    func fetchMoreNews(request: HomeModels.DisplayMoreNews.Request) {
        Task {
            do {
                guard let news = try await networkManager?.getNews(offset: request.offset) else {
                    return
                }
                storageManager?.saveNews(news.results)
                
                let response = HomeModels.DisplayMoreNews.Response(news: news, errorDescription: nil)
                presenter?.presentMoreNews(response: response)
                
            } catch RequestError.offline {
                // nothing
                // Логика поменяется, если с бд подгружать постранично
            } catch let error as RequestError {
                presenter?.presentMoreNews(response: .init(
                    news: nil,
                    errorDescription: error.description
                ))
            }
        }
    }
    
    @MainActor
    func fetchSelectedDetail(request: HomeModels.DisplayDetail.Request) {
        switch request.section {
        case .blog:
            itemDetail = storageManager?.getBlogDetail(with: request.id)
        case .news:
            itemDetail = storageManager?.getNewsDetail(with: request.id)
        }

        if itemDetail != nil {
            presenter?.presentDetail(response: .init(errorDescription: nil))
            return
        }
        
        Task {
            do {
                switch request.section {
                case .blog:
                    itemDetail = try await networkManager?.getBlogDetail(id: request.id)
                case .news:
                    itemDetail = try await networkManager?.getNewsDetail(id: request.id)
                }
                presenter?.presentDetail(response: .init(errorDescription: nil))
            } catch let error as RequestError {
                presenter?.presentDetail(response: .init(errorDescription: error.description))
            }
        }
    }
}
