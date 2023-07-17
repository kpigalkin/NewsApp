import Foundation
import RealmSwift

enum DataBaseParams {
    case all
    case id(identifier: Int)
}

protocol DataBaseService {
    func save(news: [NewsModel])
    func get(_ parameter: DataBaseParams) -> [NewsModel]?
}

final class RealmService {
    private lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)
}

extension RealmService: DataBaseService {
    func save(news: [NewsModel]) {
        news.forEach { element in
            try! mainRealm.write {
                mainRealm.add(element, update: .all)
            }
        }
    }
    
    func get(_ parameter: DataBaseParams) -> [NewsModel]? {
        switch parameter {
        case .all:
            return Array(mainRealm.objects(NewsModel.self))
        case .id(let identifier):
            guard let object = mainRealm.object(
                ofType: NewsModel.self, forPrimaryKey: identifier
            )
            else { return nil }
            return [object]
        }
    }
}
