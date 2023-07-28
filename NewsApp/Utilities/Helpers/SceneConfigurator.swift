//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit

protocol SceneConfigurator {
    associatedtype ViewController: UIViewController
    static func configure() -> ViewController
}
