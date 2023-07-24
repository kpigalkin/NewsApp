import Foundation

enum AppConstants {
    
    // MARK: - ImageWidthTarget
    
    enum ImageWidthTarget: CGFloat {
        case smallPreview = 120
        case preview = 350
        case full = 800
    }
    
    // MARK: - DateFormat

    enum DateFormat {
        static let toFormat = "MMM d, h:mm a"
    }
    
    // MARK: - Cache

    enum Cache {
        static let diskLimit: UInt = 1024 * 1024 * 20
        static let memoryLimit: Int = 1024 * 1024 * 100
    }
}
