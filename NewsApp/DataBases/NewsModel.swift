import Foundation
import RealmSwift

@objcMembers
final class NewsModel: Object, Decodable {
    dynamic var id = Int()
    dynamic var title = String()
    dynamic var summary = String()
    dynamic var url = String()
    dynamic var imageURL = String()
    dynamic var date = String()
    
    enum CodingKeys: String, CodingKey {
        case id, title, url, summary
        case imageURL = "image_url"
        case date = "published_at"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
