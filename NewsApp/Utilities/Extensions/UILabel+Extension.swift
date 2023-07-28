//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit

extension UILabel {
    convenience init(
        style: UIFont.TextStyle,
        linesCount: Int = .zero,
        breakMode: NSLineBreakMode = .byWordWrapping
    ) {
        self.init()
        font = .preferredFont(forTextStyle: style)
        numberOfLines = linesCount
        lineBreakMode = breakMode
    }
}
