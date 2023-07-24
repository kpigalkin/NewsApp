
    // MARK: - StorageError

enum StorageError: Error {
    case notFound
}

    // MARK: - Description

extension StorageError {
    var description: String {
        switch self {
        case .notFound:
            return "Data not found"
        }
    }
}
