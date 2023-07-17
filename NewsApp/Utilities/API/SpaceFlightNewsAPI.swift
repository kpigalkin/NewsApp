import Foundation

protocol EndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
    static var dateFormats: [String] { get }
}

enum SpaceFlightEndPoint: EndPoint {
    case getNews(offset: Int)
    
    var method: String {
        switch self {
        case .getNews:
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
