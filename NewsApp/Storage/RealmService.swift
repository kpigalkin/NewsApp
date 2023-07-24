import RealmSwift

final class RealmService {
    static let shared = RealmService()
    
    private var realm = try! Realm()
    
    private init() {
        // FIXME: Delete
        let realm = try! Realm()
        try! realm.write {
//            realm.deleteAll()
        }
        print("News count: \(realm.objects(NewsObject.self).count)")
        print("Blogs count: \(realm.objects(BlogObject.self).count)")
    }
}

extension RealmService {
    func addObjects<T: Object>(_ objects: [T]) {
        realm.writeAsync {
            objects.forEach {
                self.realm.add($0, update: .all)
            }
        }
    }
    
    func getAllObjects<T: Object>(_ objectClass: T.Type) -> Results<T> {
        return realm.objects(objectClass.self)
    }
    
    func getObject<T: Object>(ofType type: T.Type, forKey key: Int) -> T? {
        return realm.object(ofType: type, forPrimaryKey: key)
    }
}
