import UIKit

struct NewsListCollectionItem {
    let uuid = UUID()
    let content: ItemType
    
    init(content: ItemType) {
        self.content = content
    }
}

extension NewsListCollectionItem: Hashable {
    enum ItemType {
        case news(configuration: NewsListContentConfiguration)
    }
    
    static func == (lhs: NewsListCollectionItem, rhs: NewsListCollectionItem) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
