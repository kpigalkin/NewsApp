//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit

    // MARK: - HomeCollectionItem

struct HomeCollectionItem {
    let uuid = UUID()
    let content: ItemType
    
    init(content: ItemType) {
        self.content = content
    }
}

    // MARK: - Hashable

extension HomeCollectionItem: Hashable {
    enum ItemType {
        case blog(configuration: BlogContentConfiguration)
        case news(configuration: NewsContentConfiguration)
    }
    
    static func == (lhs: HomeCollectionItem, rhs: HomeCollectionItem) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
