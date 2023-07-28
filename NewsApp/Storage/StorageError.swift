//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

    // MARK: - StorageError

enum StorageError {
    case notFound
}

    // MARK: - Description

extension StorageError: ResponseError {
    var description: String {
        switch self {
        case .notFound:
            return "Data not found"
        }
    }
}
