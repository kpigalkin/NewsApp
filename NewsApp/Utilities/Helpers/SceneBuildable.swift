import UIKit

protocol SceneBuildable {
    associatedtype ViewController: UIViewController
    static func build() -> ViewController
}
