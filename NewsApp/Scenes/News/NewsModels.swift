import UIKit

enum News {
    enum Latest {
        struct Request {}
        struct Response: Decodable {
            let results: [NewsItem]
        }
        struct ViewModel {
            let newsItems: [NewsCollectionItem]
        }
    }
}


struct NewsItem: Decodable {
    let id: Int
    let title, url, imageURL: String
    let summary, publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, url, summary
        case imageURL = "image_url"
        case publishedAt = "published_at"
    }
}
