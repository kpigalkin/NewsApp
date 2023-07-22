enum StorageError: Error {
    case notFound
    
    var description: String {
        switch self {
        case .notFound:
            return "Data not found"
        }
    }
}
