import Foundation

    // MARK: - NewsItems

struct NewsItems: Decodable {
    let results: [News]
}

    // MARK: - News

struct News {
    let id: Int
    let title: String
    let summary: String
    let url: String
    let imageURL: String
    let date: String
}

extension News: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, url, summary
        case imageURL = "image_url"
        case date = "published_at"
    }
}

    // MARK: - News -> NewsObject

extension News {
    var object: NewsObject {
        let object = NewsObject()
        object.id = id
        object.title = title
        object.summary = summary
        object.url = url
        object.imageURL = imageURL
        object.date = date
        return object
    }
}

    // MARK: - [News] -> [NewsObject]

extension Array where Element == News {
    var objects: [NewsObject] {
        return map { $0.object }
    }
}
