//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import Foundation

    // MARK: - HTTPMethod

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
