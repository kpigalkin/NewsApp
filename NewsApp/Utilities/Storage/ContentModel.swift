import Foundation
import RealmSwift

final class ContentModel: Object {
    @objc dynamic var screen = String()

    var news = List<DetailModel>()
    var blogs = List<DetailModel>()
    
    override class func primaryKey() -> String? {
        return "screen"
    }
    
    static let key = String(describing: ContentModel.self)
}
