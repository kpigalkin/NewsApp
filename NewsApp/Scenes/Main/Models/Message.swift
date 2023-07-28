//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit

    // MARK: - Result

enum Result {
    case success
    case handeledError
    case completeError
}

    // MARK: - Message

struct Message {
    let result: Result
    let image: UIImage?
    let errorTitle: String?
    
    init(
        result: Result,
        image: UIImage? = nil,
        errorTitle: String? = nil
    ) {
        self.result = result
        self.image = image
        self.errorTitle = errorTitle
    }
}
