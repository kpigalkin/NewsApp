//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import Foundation

    // MARK: - SpaceFlightNewsEndpoint
    /// Open Space Flight News API [SNAPI] --- https://api.spaceflightnewsapi.net/v4/docs/

enum SpaceFlightNewsEndpoint {
    case blogDetail(id: Int)
    case newsDetail(id: Int)
    case news(offset: Int)
    case blogs
}

    // MARK: - Endpoint

extension SpaceFlightNewsEndpoint: Endpoint {
    var method: HTTPMethod {
        switch self {
        default:
            return .get
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
        case .blogDetail(id: let id):
            return "/v4/blogs/" + "\(id)"
        case .newsDetail(id: let id):
            return "/v4/articles/" + "\(id)"
        case .blogs:
            return "/v4/blogs/"
        case .news:
            return "/v4/articles/"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .news(offset: let offset):
            return [
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
        default:
            return []
        }
    }
}

    // MARK: - Date formats

extension SpaceFlightNewsEndpoint {
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

