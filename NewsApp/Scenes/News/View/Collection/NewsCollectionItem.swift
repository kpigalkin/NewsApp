import UIKit

struct NewsCollectionItem {
    let uuid = UUID()
    let content: ItemType
    
    init(content: ItemType) {
        self.content = content
    }
}

extension NewsCollectionItem: Hashable {
    enum ItemType {
        case news(configuration: NewsContentConfiguration)
    }
    
    static func == (lhs: NewsCollectionItem, rhs: NewsCollectionItem) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
