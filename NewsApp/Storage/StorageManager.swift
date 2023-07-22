import Foundation
import RealmSwift

protocol StorageManagingLogic {
    func getNews() -> [DetailModel]
    func getBlogs() -> [DetailModel]
    
    func getNewsDetail(with id: Int) -> DetailModel?
    func getBlogDetail(with id: Int) -> DetailModel?
    
    func saveNews(_ news: [DetailModel])
    func saveBlogs(_ blogs: [DetailModel])
}

final class StorageManager {
    
    private var newsLimit = 30
    private var blogsLimit = 10
        
    init() {
        let realm = try! Realm()
        try! realm.write({
//            realm.deleteAll()
        })
        print("NEWS COUNT HERE")
        print(getNews().count)
        print("BLOGS COUNT HERE")
        print(getBlogs().count)
    }
}

extension StorageManager: StorageManagingLogic {
    
    func getNews() -> [DetailModel] {
        return Array(storage.news)
    }
    
    func getBlogs() -> [DetailModel] {
        return Array(storage.blogs)
    }
    
    func getNewsDetail(with id: Int) -> DetailModel? {
        return storage.news.first(where: { $0.id == id })

    }
    
    func getBlogDetail(with id: Int) -> DetailModel? {
        return storage.blogs.first(where: { $0.id == id })
    }
    
    func saveNews(_ news: [DetailModel]) {
        saveAsync(items: news, to: storage.news) { [unowned self] storage in
            return trim(sort(storage), by: newsLimit)
        }
    }
    
    func saveBlogs(_ blogs: [DetailModel]) {
        saveAsync(items: blogs, to: storage.blogs) { [unowned self] storage in
            return trim(sort(storage), by: blogsLimit)
        }
    }
}

private extension StorageManager {
    var storage: StorageHomeContentModel {
        let realm = try! Realm()
        return realm.object(ofType: StorageHomeContentModel.self, forPrimaryKey: StorageHomeContentModel.uniqueKey) ?? {
            let storage = StorageHomeContentModel()
            try! realm.write { realm.add(storage) }
            return storage
        }()
    }
        
    func saveAsync(items: [DetailModel], to storage: List<DetailModel>, completion: @escaping (List<DetailModel>) -> [DetailModel]) {
        let realm = try! Realm()
        realm.writeAsync {
            items.forEach {
                if realm.object(ofType: DetailModel.self, forPrimaryKey: $0.id) == nil {
                    let model = realm.create(DetailModel.self, value: $0)
                    storage.append(model)
                }
            }
            
            let sortedTrimmed = completion(storage)
            storage.removeAll()
            storage.append(objectsIn: sortedTrimmed)
        }
    }
    
    func sort(_ items: List<DetailModel>) -> [DetailModel] {
        return items.sorted { $0.id > $1.id }
    }
    
    func trim(_ items: [DetailModel], by limit: Int) -> [DetailModel] {
        return Array(items.prefix(limit))
    }
}
