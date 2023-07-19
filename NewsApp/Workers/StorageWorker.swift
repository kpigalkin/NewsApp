import Foundation
import RealmSwift

protocol StorageWorkingLogic {
    func saveNews(_ news: [DetailModel])
    func saveBlogs(_ blogs: [DetailModel])
    func getAllNews() -> [DetailModel]?
    func getAllBlogs() -> [DetailModel]?
    func getNewsDetail(with id: Int) -> DetailModel?
    func getBlogDetail(with id: Int) -> DetailModel?
}

final class StorageWorker {
    private lazy var realm: Realm = configureRealm()
}

extension StorageWorker: StorageWorkingLogic {
    
    func getAllNews() -> [DetailModel]? {
        return Array(contentModel.news)
    }
    
    func getAllBlogs() -> [DetailModel]? {
        return Array(contentModel.blogs)
    }
    
    func getNewsDetail(with id: Int) -> DetailModel? {
        return contentModel.news.first(where: { $0.id == id })
    }
    
    func getBlogDetail(with id: Int) -> DetailModel? {
        return contentModel.blogs.first(where: { $0.id == id })
    }
    
    func saveNews(_ news: [DetailModel]) {
        realm.writeAsync {
            news.forEach { item in
                let dbItem = self.realm.object(ofType: DetailModel.self, forPrimaryKey: item.id) ?? {
                    self.realm.create(DetailModel.self, value: item)
                    return self.realm.object(ofType: DetailModel.self, forPrimaryKey: item.id)
                }()
                self.contentModel.news.append(dbItem!)
            }
        }
    }
    
    func saveBlogs(_ blogs: [DetailModel]) {
        let content = contentModel
        realm.writeAsync {
            content.blogs.removeAll()
            blogs.forEach { item in
                let dbItem = self.realm.object(ofType: DetailModel.self, forPrimaryKey: item.id) ?? {
                    self.realm.create(DetailModel.self, value: item)
                    return self.realm.object(ofType: DetailModel.self, forPrimaryKey: item.id)
                }()
                content.blogs.append(dbItem!)
            }
        }
    }
}

private extension StorageWorker {
    
    var contentModel: ContentModel {
        let content = realm.object(ofType: ContentModel.self, forPrimaryKey: ContentModel.key)
        return content ?? .init()
    }
    
    func configureRealm() -> Realm {
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            
            if realm.objects(ContentModel.self).isEmpty {
                let contentModel = ContentModel()
                contentModel.screen = ContentModel.key
                try realm.write {
                    realm.add(contentModel)
                }
            }
            
            return realm
        } catch {
            fatalError("Ошибка инициализации базы данных Realm: \(error)")
        }
    }
}
