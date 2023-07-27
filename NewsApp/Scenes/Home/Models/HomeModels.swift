import UIKit

enum HomeModels {
    
    // MARK: - Display More News UseCase
    
    enum DisplayMoreNews {
        struct Request {
            let offset: Int
        }
        struct Response {
            let news: [News]?
            let success: Bool
            let error: ResponseError?
        }
        struct ViewModel {
            let news: [HomeCollectionItem]
            let message: Message
        }
    }
    
    // MARK: - Display News & Blogs Use Case
    
    enum DisplayContent {
        struct Request {}
        struct Response {
            let blogs: [Blog]?
            let news: [News]?
            let success: Bool
            let error: ResponseError?
        }
        struct ViewModel {
            let news: [HomeCollectionItem]
            let blogs: [HomeCollectionItem]
            let message: Message
        }
    }
    
    // MARK: - Display Detail use case

    enum DisplayDetail {
        struct Request {
            let id: Int
            let section: HomeSection
        }
        struct Response {
            let success: Bool
            let error: ResponseError?
        }
        struct ViewModel {
            let message: Message
        }
    }
}
