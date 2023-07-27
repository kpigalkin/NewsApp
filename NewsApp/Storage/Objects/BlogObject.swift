//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import RealmSwift

    // MARK: - BlogObject

@objcMembers
final class BlogObject: Object {
    dynamic var id = Int()
    dynamic var title = String()
    dynamic var summary = String()
    dynamic var url = String()
    dynamic var imageURL = String()
    dynamic var date = String()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

    // MARK: - BlogObject -> Blog

extension BlogObject {
    var model: Blog {
        .init(id: id,
              title: title,
              summary: summary,
              url: url,
              imageURL: imageURL,
              date: date
        )
    }
}

    // MARK: - Results<BlogObject> -> [Blog]

extension Results where Element == BlogObject {
    var models: [Blog] {
        return self.map { $0.model }
    }
}
