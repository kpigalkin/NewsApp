import Foundation
import RealmSwift

protocol StorageWorkingLogic {
    func getNews() -> [News]
    func getBlogs() -> [Blog]
    func getNewsDetail(with id: Int) throws -> News?
    func getBlogDetail(with id: Int) throws -> Blog?

    func saveNews(_ news: [News])
    func saveBlogs(_ blogs: [Blog])
}

final class StorageWorker {
    var storageService: RealmService?
}

extension StorageWorker: StorageWorkingLogic {
    func getNews() -> [News] {
        storageService?.getAllObjects(NewsObject.self).models ?? []
    }
    
    func getBlogs() -> [Blog] {
        storageService?.getAllObjects(BlogObject.self).models ?? []
    }
    
    func getNewsDetail(with id: Int) throws -> News? {
        guard let object = storageService?.getObject(ofType: NewsObject.self, forKey: id) else {
            throw StorageError.notFound
        }
        return object.model
    }
    
    func getBlogDetail(with id: Int) throws -> Blog? {
        guard let object = storageService?.getObject(ofType: BlogObject.self, forKey: id) else {
            throw StorageError.notFound
        }
        return object.model
    }
    
    func saveNews(_ news: [News]) {
        storageService?.addObjects(news.objects)
    }
    
    func saveBlogs(_ blogs: [Blog]) {
        storageService?.addObjects(blogs.objects)
    }
}
