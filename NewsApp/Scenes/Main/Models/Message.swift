import UIKit

enum Result {
    case success
    case handeledError
    case completeError
}

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
