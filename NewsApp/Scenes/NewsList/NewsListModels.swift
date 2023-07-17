import UIKit

enum NewsListModels {
    enum Show {
        struct Request {
            let offset: Int
        }
        struct Response: Decodable {
            let results: [NewsModel]
        }
        struct ViewModel {
            let newsItems: [NewsListCollectionItem]
        }
    }
    
    enum SelectElement {
        struct Request {
            let index: Int
        }
    }
}
