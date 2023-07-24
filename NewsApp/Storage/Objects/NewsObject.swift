import RealmSwift

@objcMembers
final class NewsObject: Object {
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

extension NewsObject {
    var model: News {
        .init(id: id,
              title: title,
              summary: summary,
              url: url,
              imageURL: imageURL,
              date: date
        )
    }
}

extension Results where Element == NewsObject {
    var models: [News] {
        return self.map { $0.model }
    }
}
