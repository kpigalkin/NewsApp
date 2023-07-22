import Kingfisher
import UIKit

extension KingfisherWrapper<UIImageView> {
    func setImage(with url: URL?, targetWidth: AppConstants.ImageSize) {
        let resizeTransform = ResizingImageProcessor(
            referenceSize: CGSize(
                width: targetWidth.rawValue,
                height: CGFloat.greatestFiniteMagnitude
            ),
            mode: .aspectFit
        )
        setImage(with: url, options: [.processor(resizeTransform), .cacheOriginalImage])
    }
}
