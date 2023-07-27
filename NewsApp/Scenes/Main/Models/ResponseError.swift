//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

protocol ResponseError: Error {
    var description: String { get }
}
