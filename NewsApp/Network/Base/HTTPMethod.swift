import Foundation

enum HTTPMethod: String {
    case delete
    case get
    case patch
    case post
    case put
    
    var name: String {
        return rawValue.uppercased()
    }
}
