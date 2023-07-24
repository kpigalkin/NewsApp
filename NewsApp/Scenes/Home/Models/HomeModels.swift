import UIKit

enum HomeModels {
    
    enum DisplayMoreNews {
        struct Request {
            let offset: Int
        }
        struct Response {
            let news: [News]?
            let errorDescription: String?
        }
        struct ViewModel {
            let news: [HomeCollectionItem]
            let errorDescription: String?
        }
    }
    
    enum DisplayContent {
        struct Request {}
        struct Response {
            let blogs: [Blog]?
            let news: [News]?
            let errorDescription: String?
        }
        struct ViewModel {
            let news: [HomeCollectionItem]
            let blogs: [HomeCollectionItem]
            let errorDescription: String?
        }
    }
    
    enum DisplayDetail {
        struct Request {
            let id: Int
            let section: HomeSection
        }
        struct Response {
            let errorDescription: String?
        }
        struct ViewModel {
            let errorDescription: String?
        }
    }
}
