import UIKit

protocol SceneConfigurator {
    associatedtype ViewController: UIViewController
    static func configure() -> ViewController
}
