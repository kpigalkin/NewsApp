import UIKit

enum NewsListModels {
    enum ShowNews {        
        struct Request {
            let offset: Int
        }
        struct Response {
            let news: NewsListModel
            let error: RequestError?
        }
        struct ViewModel {
            let news: [NewsListCollectionItem]
            let success: Bool
            let errorTitle: String?
            let errorMessage: String?
        }
    }
    
    enum SelectElement {
        struct Request {
            let index: Int
        }
    }
}
