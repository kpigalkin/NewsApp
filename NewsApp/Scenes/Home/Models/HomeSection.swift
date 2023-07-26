enum HomeSection: Int {
    case blog
    case news
}

extension HomeSection {
    var name: String {
        switch self {
        case .blog:
            return "Latests blogs"
        case .news:
            return "News"
        }
    }
}
