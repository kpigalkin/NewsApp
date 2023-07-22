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

private extension HomeInteractor {

}

extension HomeInteractor: HomeBusinessLogic {
    func fetchContent(request: HomeModels.DisplayContent.Request) {
        Task {
            do {
                async let newsRequest = networkManager?.getNews(offset: .zero)
                async let blogRequest = networkManager?.getBlogs()
                
                guard let news = try await newsRequest,
                      let blogs = try await blogRequest else { return }
                
                await MainActor.run {
                    storageManager?.saveBlogs(blogs.results)
                    storageManager?.saveNews(news.results)
                    
                    let response = HomeModels.DisplayContent.Response(
                        blogs: blogs,
                        news: news,
                        errorDescription: nil
                    )
                    presenter?.presentContent(response: response)
                }
            } catch let error as RequestError {
                // TRY STORAGE
                await MainActor.run {
                    guard let dbNews = storageManager?.getNews(),
                          let dbBlogs = storageManager?.getBlogs() else { return }
                    
                    let news = HomeContentItems(results: dbNews)
                    let blogs = HomeContentItems(results: dbBlogs)
                    let response = HomeModels.DisplayContent.Response(blogs: blogs, news: news, errorDescription: error.description)
                    presenter?.presentContent(response: response)
                }
                
            } catch let error as StorageError {
                
                await MainActor.run {
                    let response = HomeModels.DisplayContent.Response(blogs: nil, news: nil, errorDescription: error.description)
                    presenter?.presentContent(response: response)
                }
            }
        }
    }
    
    func fetchMoreNews(request: HomeModels.DisplayMoreNews.Request) {
        Task {
            do {

                guard let news = try await networkManager?.getNews(offset: request.offset) else {
                    return
                }
                
                await MainActor.run {
                    storageManager?.saveNews(news.results)
                    
                    let response = HomeModels.DisplayMoreNews.Response(news: news, errorDescription: nil)
                    presenter?.presentMoreNews(response: response)
                }
                
            } catch let error as RequestError {

                guard let dbNews = storageManager?.getNews() else { return }
                
                let response = HomeModels.DisplayMoreNews.Response(
                    news: HomeContentItems(results: dbNews),
                    errorDescription: error.description
                )
                
                await MainActor.run {
                    presenter?.presentMoreNews(response: response)
                }
                
            } catch let error as StorageError {
                
                await MainActor.run {
                    let response = HomeModels.DisplayMoreNews.Response(news: nil, errorDescription: error.description)
                    presenter?.presentMoreNews(response: response)
                }
            } catch let error {
                await MainActor.run {
                    presenter?.presentMoreNews(response: .init(
                        news: nil,
                        errorDescription: error.localizedDescription
                    ))
                }
            }
        }
    }
    
    func fetchSelectedDetail(request: HomeModels.DisplayDetail.Request) {
        
        
        switch request.section {
        case .blog:
            itemDetail = storageManager?.getBlogDetail(with: request.id)
        case .news:
            itemDetail = storageManager?.getNewsDetail(with: request.id)
        }

        guard itemDetail == nil else {
            presenter?.presentDetail(response: .init(errorDescription: nil))
            return
        }
        
        // TRY NETWORK
        Task {
            do {
                switch request.section {
                case .blog:
                    itemDetail = try await networkManager?.getBlogDetail(id: request.id)
                case .news:
                    itemDetail = try await networkManager?.getNewsDetail(id: request.id)
                }
                await MainActor.run {
                    presenter?.presentDetail(response: .init(errorDescription: nil))
                }
            } catch let error as RequestError {
                await MainActor.run {
                    presenter?.presentDetail(response: .init(errorDescription: error.description))
                }
            }
        }
    }
}
