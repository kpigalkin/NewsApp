import UIKit

enum HomeModels {
    
    enum DisplayMoreNews {
        struct Request {
            let offset: Int
        }
        struct Response {
            let news: HomeContentItems
            let error: RequestError?
        }
        struct ViewModel {
            let news: [HomeCollectionItem]
            let success: Bool
            let errorTitle: String?
            let errorMessage: String?
        }
    }
    
    enum DisplayContent {
        struct Request {}
        struct Response {
            let blogs: HomeContentItems
            let news: HomeContentItems
            let error: RequestError?
        }
        struct ViewModel {
            let news: [HomeCollectionItem]
            let blogs: [HomeCollectionItem]
            let success: Bool
            let errorTitle: String?
            let errorMessage: String?
        }
    }
    
    enum DisplayDetail {
        struct Request {
            let id: Int
            let forSection: HomeSection
        }
        struct Response {
            let error: Error?
        }
        struct ViewModel {
            let success: Bool
            let errorTitle: String?
            let errorMessage: String?
        }
    }
}

struct HomeContentItems: Decodable {
    let results: [DetailModel]
}
