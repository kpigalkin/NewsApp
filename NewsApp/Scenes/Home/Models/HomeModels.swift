import UIKit

enum HomeModels {
    
    enum DisplayNews {        
        struct Request {
            let offset: Int
        }
        struct Response {
            let news: HomeContentModel
            let error: RequestError?
        }
        struct ViewModel {
            let news: [HomeCollectionItem]
            let success: Bool
            let errorTitle: String?
            let errorMessage: String?
        }
    }
    
    enum DisplayBlogs {
        struct Request {}
        struct Response {
            let blogs: HomeContentModel
            let error: RequestError?
        }
        struct ViewModel {
            let blogs: [HomeCollectionItem]
            let success: Bool
            let errorTitle: String?
            let errorMessage: String?
        }
    }
    
    enum DisplayNewsDetail {
        struct Request {
            let id: Int
        }
    }
    
    enum DisplayBlogDetail {
        struct Request {
            let id: Int
        }
    }
}

struct HomeContentModel: Decodable {
    let results: [DetailModel]
}
