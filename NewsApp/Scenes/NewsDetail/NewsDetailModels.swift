import UIKit

enum NewsDetail {
    enum ShowElement {
        struct Request {}
        struct Response {
            let element: NewsModel
        }
        struct ViewModel {
            let id: Int
            let url, imageURL: URL?
            let title, summary, publishDate: String
        }
    }
}
