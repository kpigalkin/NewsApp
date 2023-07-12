import UIKit

protocol NewsDisplayLogic: AnyObject {
    func displayNews(viewModel: News.Load.ViewModel)
}

protocol NewsViewEvents: AnyObject {
    func someButtonTapped()
}

final class NewsViewController: UIViewController {
    private lazy var newsView: (NewsDisplayLogic & UIView) = NewsView(frame: UIScreen.main.bounds)

    var interactor: NewsBusinessLogic?
    var router: (NewsRoutingLogic & NewsDataPassing)?
    
    override func loadView() {
        view = newsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
    }
}

private extension NewsViewController {
    func doSomething() {
        let request = News.Load.Request()
        interactor?.doSomething(request: request)
    }
}

extension NewsViewController: NewsViewEvents {
    func someButtonTapped() {
//        let request = News.Load.Request()
//        interactor?.doSomething(request: request)
    }
}

extension NewsViewController: NewsDisplayLogic {
    func displayNews(viewModel: News.Load.ViewModel) {
        newsView.displayNews(viewModel: viewModel)
    }
}
