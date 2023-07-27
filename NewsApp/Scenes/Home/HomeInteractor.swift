
    // MARK: - Protocols

protocol HomeBusinessLogic {
    func fetchContent(request: HomeModels.DisplayContent.Request)
    func fetchMoreNews(request: HomeModels.DisplayMoreNews.Request)
    func fetchSelectedDetail(request: HomeModels.DisplayDetail.Request)
}

protocol HomeDataStore {
    var detailContent: DetailContent? { get set }
}

    // MARK: - HomeInteractor

final class HomeInteractor: HomeDataStore {
    var networkWorker: HomeNetworkWorkingLogic?
    var storageWorker: StorageWorkingLogic?
    var presenter: HomePresentationLogic?
    
    var detailContent: DetailContent?
}

    // MARK: - HomeBusinessLogic

extension HomeInteractor: HomeBusinessLogic {
    @MainActor
    func fetchContent(request: HomeModels.DisplayContent.Request) {
        Task {
            do {

                async let newsRequest = networkWorker?.getNews(offset: .zero)
                async let blogRequest = networkWorker?.getBlogs()
                
                guard
                    let news = try await newsRequest,
                    let blogs = try await blogRequest
                else {
                    return
                }

                defer {
                    storageWorker?.saveBlogs(blogs.results)
                    storageWorker?.saveNews(news.results)
                }

                presenter?.presentContent(response: .init(
                    blogs: blogs.results,
                    news: news.results,
                    success: true,
                    error: nil
                ))

            } catch let error as RequestError {
                
                presenter?.presentContent(response: .init(
                    blogs: storageWorker?.getBlogs(),
                    news: storageWorker?.getNews(),
                    success: true,
                    error: error
                ))
                
            } catch let error as StorageError {
                
                presenter?.presentContent(response: .init(
                    blogs: nil,
                    news: nil,
                    success: false,
                    error: error
                ))
            }
        }
    }
    
    @MainActor
    func fetchMoreNews(request: HomeModels.DisplayMoreNews.Request) {
        Task {
            do {
                
                guard let news = try await networkWorker?.getNews(offset: request.offset) else {
                    return
                }
                
                defer {
                    storageWorker?.saveNews(news.results)
                }
                
                presenter?.presentMoreNews(response: .init(
                    news: news.results,
                    success: true,
                    error: nil
                ))
                
            } catch let error as RequestError {
                
                presenter?.presentMoreNews(response: .init(
                    news: nil,
                    success: false,
                    error: error
                ))
            }
        }
    }
    
    @MainActor
    func fetchSelectedDetail(request: HomeModels.DisplayDetail.Request) {
        Task {
            do {
                
                switch request.section {
                case .blog:
                    let blog = try storageWorker?.getBlogDetail(with: request.id)
                    detailContent = .init(blog: blog)
                case .news:
                    let news = try storageWorker?.getNewsDetail(with: request.id)
                    detailContent = .init(news: news)
                }
                presenter?.presentDetail(response: .init(success: true, error: nil))
                
            } catch let error as StorageError {
                
                switch request.section {
                case .blog:
                    let blog = try await networkWorker?.getBlogDetail(id: request.id)
                    detailContent = .init(blog: blog)
                case .news:
                    let news = try await networkWorker?.getNewsDetail(id: request.id)
                    detailContent = .init(news: news)
                }
                presenter?.presentDetail(response: .init(success: true, error: error))
                
            } catch let error as RequestError {
                presenter?.presentDetail(response: .init(success: false, error: error))
            }
        }
    }
}
