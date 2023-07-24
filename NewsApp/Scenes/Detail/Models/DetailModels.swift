import UIKit

enum Detail {
    
    // MARK: - Display Detail Use Case
    
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
