import UIKit

enum Detail {
    enum Display {
        struct Request {}
        struct Response {
            let content: DetailContent
        }
        struct ViewModel {
            let id: Int
            let url, imageURL: URL?
            let title, summary, publishDate: String
        }
    }
}

struct DetailContent {
    var news: News?
    var blog: Blog?
}
