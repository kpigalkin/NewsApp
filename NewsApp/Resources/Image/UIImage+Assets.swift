import UIKit

extension UIImage {
    static let placeholder = UIImage(named: "placeholder")
    enum ImageWidthTarget: CGFloat {
        case preview = 150
        case full = 800
    }
}
