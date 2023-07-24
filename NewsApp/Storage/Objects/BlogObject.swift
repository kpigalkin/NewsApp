import RealmSwift

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

extension Results where Element == BlogObject {
    var models: [Blog] {
        return self.map { $0.model }
    }
}
