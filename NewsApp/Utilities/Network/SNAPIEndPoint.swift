/// Open Space Flight News API [SNAPI] --- https://api.spaceflightnewsapi.net/v4/docs/

import Foundation

protocol EndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
    static var dateFormats: [String] { get }
}

enum SNAPIEndPoint: EndPoint {
    case getBlogDetail(id: Int)
    case getNewsDetail(id: Int)
    case getNews(offset: Int)
    case getLatestBlogs
    case getLatestNews
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }

    var host: String {
        switch self {
        default:
            return "api.spaceflightnewsapi.net"
        }
    }
    
    var path: String {
        switch self {
        case .getBlogDetail(id: let id):
            return "/v4/blogs/" + "\(id)"
        case .getNewsDetail(id: let id):
            return "/v4/articles/" + "\(id)"
        case .getLatestBlogs:
            return "/v4/blogs"
        default:
            return "/v4/articles"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getNews(offset: let offset):
            return [
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
        default:
            return []
        }
    }
    
    static var dateFormats: [String] {
        switch self {
        default:
            return [
                "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ",
                "yyyy-MM-dd'T'HH:mm:ssZ"
            ]
        }
    }
}
