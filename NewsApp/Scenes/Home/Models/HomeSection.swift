//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

enum HomeSection: Int {
    case blog
    case news
}

extension HomeSection {
    var name: String {
        switch self {
        case .blog:
            return String.blogsSectionName
        case .news:
            return String.newsSectionName
        }
    }
}
