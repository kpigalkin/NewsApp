import Foundation
import RealmSwift

struct HomeContentItems: Decodable {
    let results: [DetailModel]
}

@objcMembers
final class DetailModel: Object {
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

extension DetailModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, url, summary
        case imageURL = "image_url"
        case date = "published_at"
    }
}
