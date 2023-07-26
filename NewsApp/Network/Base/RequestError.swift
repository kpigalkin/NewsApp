import Foundation

    // MARK: - RequestError

enum RequestError: Error {
    case invalidURL
    case decode
    case offline
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case internalServerError
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case other(Int)
}

extension RequestError {
    
    // MARK: - Description
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decode:
            return "Decode Error"
        case .offline:
            return "Offline idk"
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .internalServerError:
            return "Internal Server Error"
        case .badGateway:
            return "Bad Gateway"
        case .serviceUnavailable:
            return "Service Unavailable"
        case .gatewayTimeout:
            return "Gateway Timeout"
        case .other(let statusCode):
            return "Error with status code: \(statusCode)"
        }
    }
    
    // MARK: - Status Code Handling
    
    static func handleResponseError(statusCode: Int) -> RequestError {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500:
            return .internalServerError
        case 502:
            return .badGateway
        case 503:
            return .serviceUnavailable
        case 504:
            return .gatewayTimeout
        default:
            return .other(statusCode)
        }
    }
}