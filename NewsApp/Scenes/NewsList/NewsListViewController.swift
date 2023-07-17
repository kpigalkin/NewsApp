import UIKit

protocol NewsListDisplayLogic: AnyObject {
    func displayNews(viewModel: NewsListModels.Show.ViewModel)
}

final class NewsListViewController: UIViewController {
    static let cellReuseIdentifier = "NewsListCell"
    
    // MARK: - Public
    
    var interactor: NewsListBusinessLogic?
    var router: (NewsListRoutingLogic & NewsListDataPassing)?
    
    // MARK: - Private
    
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, NewsListContentConfiguration> { cell, indexPath, configuration in
        cell.contentConfiguration = nil
        cell.contentConfiguration = configuration
    }
        
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: NewsListCollectionViewLayoutFactory.newsFeedLayout()
        )
        view.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: NewsListViewController.cellReuseIdentifier
        )
        view.delegate = self
        view.backgroundColor = .darkGray
        return view
    }()
    
    private lazy var dataSource = makeDataSource()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSections()
        addSubviews()
        configureConstraints()
        requestToFetchNews()
    }
}

extension NewsListViewController: NewsListDisplayLogic {
    
    // MARK: - Display
    
    func displayNews(viewModel: NewsListModels.Show.ViewModel) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(viewModel.newsItems, toSection: .newsList)
        dataSource.apply(snapshot)
    }
    
    // MARK: - Request
    
    private func requestToFetchNews() {
        interactor?.fetchNews(request: .init())
    }
    
    private func requestToSelectNewsElement(by id: Int) {
        interactor?.selectNewsElement(request: .init(index: id))
    }
    
    // MARK: - Route
    
    private func routeToNewsDetail() {
        router?.routeToNewsDetail()
    }
}

    // MARK: - UICollectionViewDelegate

extension NewsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        guard let config = cell?.contentConfiguration as? NewsListContentConfiguration else {
            return
        }
        requestToSelectNewsElement(by: config.id)
        routeToNewsDetail() 
    }
}

private extension NewsListViewController {
    
    // MARK: - UICollectionViewDiffableDataSource
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<NewsListSection, NewsListCollectionItem> {
        let dataSource = UICollectionViewDiffableDataSource<NewsListSection, NewsListCollectionItem>(collectionView: collectionView) {
            [weak self] collectionView, indexPath, item in
            guard let self else { return .init(frame: .zero) }
            switch item.content {
            case .news(configuration: let configuration):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.cellRegistration,
                    for: indexPath,
                    item: configuration
                )
            }
        }
        return dataSource
    }
    
    func createSections() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.newsList])
        dataSource.apply(snapshot)
    }
    
    // MARK: - Constraints
    
    func addSubviews() {
        view.addSubview(collectionView)
    }
    
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
