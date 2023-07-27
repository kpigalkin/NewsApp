//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import Foundation

    // MARK: - BlogItems

struct BlogItems: Decodable {
    let results: [Blog]
}

    // MARK: - Blog

struct Blog {
    let id: Int
    let title: String
    let summary: String
    let url: String
    let imageURL: String
    let date: String
}

extension Blog: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, url, summary
        case imageURL = "image_url"
        case date = "published_at"
    }
}

    // MARK: - Blog -> BlogObject

extension Blog {
    var object: BlogObject {
        let object = BlogObject()
        object.id = id
        object.title = title
        object.summary = summary
        object.url = url
        object.imageURL = imageURL
        object.date = date
        return object
    }
}

    // MARK: - [Blog] -> [BlogObject]

extension Array where Element == Blog {
    var objects: [BlogObject] {
        return map { $0.object }
    }
}
