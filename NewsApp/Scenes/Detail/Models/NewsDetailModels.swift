import UIKit

enum Detail {
    enum Display {
        struct Request {}
        struct Response {
            let element: DetailModel
        }
        struct ViewModel {
            let id: Int
            let url, imageURL: URL?
            let title, summary, publishDate: String
        }
    }
}