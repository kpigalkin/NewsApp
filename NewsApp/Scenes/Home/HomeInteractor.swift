
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
                    errorDescription: nil
                ))

            } catch let error as RequestError {
                
                presenter?.presentContent(response: .init(
                    blogs: storageWorker?.getBlogs(),
                    news: storageWorker?.getNews(),
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
            guard let news = try await networkWorker?.getNews(offset: request.offset) else {
                return
            }
            
            defer {
                storageWorker?.saveNews(news.results)
            }
            
            let response = HomeModels.DisplayMoreNews.Response(news: news.results, errorDescription: nil)
            presenter?.presentMoreNews(response: response)
        }
    }
    
    @MainActor
    func fetchSelectedDetail(request: HomeModels.DisplayDetail.Request) {
        do {
            switch request.section {
            case .blog:
                detailContent = .init(
                    news: nil,
                    blog: try storageWorker?.getBlogDetail(with: request.id)
                )
            case .news:
                detailContent = .init(
                    news: try storageWorker?.getNewsDetail(with: request.id),
                    blog: nil
                )
            }
            presenter?.presentDetail(response: .init(errorDescription: nil))
            
        } catch let error as StorageError {
            
            Task {
                do {
                    switch request.section {
                    case .blog:
                        detailContent?.blog = try await networkWorker?.getBlogDetail(id: request.id)
                    case .news:
                        detailContent?.news = try await networkWorker?.getNewsDetail(id: request.id)
                    }
                    presenter?.presentDetail(response: .init(errorDescription: error.description))
                } catch let error as RequestError {
                    presenter?.presentDetail(response: .init(errorDescription: error.description))
                }
            }
            
        } catch let error {
            presenter?.presentDetail(response: .init(errorDescription: error.localizedDescription))
        }
    }
}
