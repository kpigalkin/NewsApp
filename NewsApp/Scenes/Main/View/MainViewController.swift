//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit
import SwiftMessages

public typealias MessageAligment = SwiftMessages.PresentationStyle

class MainViewController: UIViewController {
    
    // MARK: - Private
    
    private enum Constants {
        static let customMessageNibName = "CustomMessageView"
        static let duration: CGFloat = 2.5
    }
    
    // MARK: - Public
    
    func messageIfNeeded(_ message: Message) {
        guard
            message.result != .success,
            let title = message.errorTitle,
            let image = message.image
        else {
            return
        }
        
        let style: MessageAligment = message.result == .handeledError ? .top : .center
        let config = makeMessageConfiguration(style: style)
        let messageView = configureMessage(title: title, withImage: image)
        
        SwiftMessages.show(config: config, view: messageView)
    }
}

    // MARK: - SwiftMessages setup

private extension MainViewController {
    
    func configureMessage(title: String, withImage image: UIImage) -> MessageView {
        guard
            let view = try? SwiftMessages.viewFromNib(named: Constants.customMessageNibName),
            let view = view as? MessageView
        else {
            return MessageView.viewFromNib(layout: .messageView)
        }
        
        view.configureContent(title: title, body: "", iconImage: image)
        return view
    }
    
    func makeMessageConfiguration(style: SwiftMessages.PresentationStyle) -> SwiftMessages.Config {
        var config = SwiftMessages.Config()
        config.presentationStyle = style
        config.interactiveHide = true
        config.presentationContext = .window(windowLevel: .statusBar)
        config.duration = .seconds(seconds: Constants.duration)
        return config
    }
}
