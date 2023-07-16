import UIKit

enum NewsListModels {
    enum Show {
        struct Request {}
        struct Response: Decodable {
            let results: [NewsListItem]
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
