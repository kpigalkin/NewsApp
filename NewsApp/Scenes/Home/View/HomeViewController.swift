import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayNews(viewModel: HomeModels.DisplayNews.ViewModel)
    func displayBlogs(viewModel: HomeModels.DisplayBlogs.ViewModel)
}

final class HomeViewController: UIViewController {
    static let cellReuseIdentifier = String(describing: HomeViewController.self)
    
    // MARK: - Public
    
    var interactor: HomeBusinessLogic?
    var router: (HomeRoutingLogic & HomeDataPassing)?
    
    // MARK: - Private
    
    private enum Constants {
        static let refreshText = "Updating"
    }
    
    private let newsCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, NewsContentConfiguration> { cell, indexPath, configuration in
        cell.contentConfiguration = nil
        cell.contentConfiguration = configuration
    }
    
    private let blogCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, BlogContentConfiguration> { cell, indexPath, configuration in
        cell.contentConfiguration = nil
        cell.contentConfiguration = configuration
    }
    
    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: HomeCollectionViewLayoutFactory.contentLayout()
        )
        view.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: HomeViewController.cellReuseIdentifier
        )
        view.delegate = self
        view.prefetchDataSource = self
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.requestToFetchBlogs()
                self.requestToFetchNews(offset: .zero)
            }),
            for: .valueChanged
        )
        control.attributedTitle = NSMutableAttributedString(string: Constants.refreshText)
        return control
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        createSections()
        addSubviews()
        configureConstraints()
        fetchContent()
    }
}

extension HomeViewController: HomeDisplayLogic {
    
    // MARK: Display
    
    func displayNews(viewModel: HomeModels.DisplayNews.ViewModel) {
        if !viewModel.success {
            throwAlert(title: viewModel.errorTitle, message: viewModel.errorMessage)
        }
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(viewModel.news, toSection: .news)
        dataSource.apply(snapshot)
        
        refreshControl.endRefreshing()
    }
    
    func displayBlogs(viewModel: HomeModels.DisplayBlogs.ViewModel) {
        if !viewModel.success {
            throwAlert(title: viewModel.errorTitle, message: viewModel.errorMessage)
        }

        var snapshot = dataSource.snapshot()
        snapshot.appendItems(viewModel.blogs, toSection: .blog)
        dataSource.apply(snapshot)

        refreshControl.endRefreshing()
    }
    
    private func throwAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: Request
    
    private func requestToFetchNews(offset: Int) {
        interactor?.fetchNews(request: .init(offset: offset))
    }
    
    private func requestToFetchBlogs() {
        interactor?.fetchBlogs(request: .init())
    }
    
    private func requestToDisplayNewsDetail(by id: Int) {
        interactor?.fetchSelectedNews(request: .init(id: id))
    }
    
    private func requestToDisplayBlogDetail(by id: Int) {
        interactor?.fetchSelectedNews(request: .init(id: id))
    }
    
    func fetchContent() {
        refreshControl.beginRefreshing()
        requestToFetchBlogs()
        requestToFetchNews(offset: .zero)
    }
    
    // MARK: Route
    
    private func routeToDetail() {
        router?.routeToDetail()
    }
}

    // MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellConfiguration = collectionView.cellForItem(at: indexPath)?.contentConfiguration
        
        if let config = cellConfiguration as? NewsContentConfiguration {
            requestToDisplayNewsDetail(by: config.id)
            routeToDetail()
        } else if let config = cellConfiguration as? BlogContentConfiguration {
            requestToDisplayBlogDetail(by: config.id)
            routeToDetail()
        }
    }
}

    // MARK: - UICollectionViewDataSourcePrefetching
    // FIXME: Not working

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        guard indexPaths.first?.section == HomeSection.news.rawValue else {
//            return
//        }
//        let itemsCount = dataSource.snapshot().numberOfItems(inSection: .news)
//        guard indexPaths.last?.row == itemsCount - 1 else { return }
//        requestToFetchNews(offset: itemsCount)
    }
}

private extension HomeViewController {
    
    // MARK: - UICollectionViewDiffableDataSource
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<HomeSection, HomeCollectionItem> {
        let dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeCollectionItem>(collectionView: collectionView) {
            [weak self] collectionView, indexPath, item in
            guard let self else { return .init(frame: .zero) }
            switch item.content {
            case .blog(configuration: let configuration):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.blogCellRegistration,
                    for: indexPath,
                    item: configuration
                )
            case .news(configuration: let configuration):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.newsCellRegistration,
                    for: indexPath,
                    item: configuration
                )
            }
        }
        return dataSource
    }
    
    func createSections() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.blog, .news])
        dataSource.apply(snapshot)
    }
    
    // MARK: - Subviews
    
    func addSubviews() {
        view.addSubview(collectionView)
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: - Constraints
    
    func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
