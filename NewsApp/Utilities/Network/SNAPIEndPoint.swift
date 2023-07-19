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
    case getNews(offset: Int)
    case getBlogs
    
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
        case .getNews:
            return "/v4/articles"
        case .getBlogs:
            return "/v4/blogs"
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
