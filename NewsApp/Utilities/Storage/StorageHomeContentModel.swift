import Foundation
import RealmSwift

final class StorageHomeContentModel: Object {
    static let uniqueKey = String(describing: StorageHomeContentModel.self)
    
    @objc dynamic var scene = StorageHomeContentModel.uniqueKey

    var blogs = List<DetailModel>()
    var news = List<DetailModel>()
    
    override class func primaryKey() -> String? {
        return "scene"
    }
}
