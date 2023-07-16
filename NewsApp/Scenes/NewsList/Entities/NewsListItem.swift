import Foundation

struct NewsListItem: Decodable {
    let id: Int
    let title, url, imageURL: String
    let summary, publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, url, summary
        case imageURL = "image_url"
        case publishedAt = "published_at"
    }
}
