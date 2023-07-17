enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case offline
    case unknown
}

extension RequestError {
    var title: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "There's no response"
        case .offline:
            return "There's not interner connection"
        case .unknown:
            return "Unwknown error"
        }
    }
    
    var message: String {
        switch self {
        case .decode:
            return "Decode description"
        case .invalidURL:
            return "Invalid URL description"
        case .noResponse:
            return "No response description"
        case .offline:
            return "There's not internet connection description"
        case .unknown:
            return "Unwknown error description"
        }
    }
}
