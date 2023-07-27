//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import RealmSwift

final class RealmService {
    // MARK: - Static
    static let shared = RealmService()
    
    // MARK: - Private
    private var realm = try! Realm()
    private init() {}
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
