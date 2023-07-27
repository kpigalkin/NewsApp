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
