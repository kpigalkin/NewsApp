//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import Kingfisher
import UIKit

extension KingfisherWrapper<UIImageView> {
    func setImage(with url: URL?, targetWidth: UIImage.ImageWidthTarget) {
        let resizeTransform = ResizingImageProcessor(
            referenceSize: CGSize(
                width: targetWidth.rawValue,
                height: CGFloat.greatestFiniteMagnitude
            ),
            mode: .aspectFit
        )
        setImage(
            with: url,
            placeholder: UIImage.placeholder,
            options: [.processor(resizeTransform), .cacheOriginalImage]
        )
    }
}
