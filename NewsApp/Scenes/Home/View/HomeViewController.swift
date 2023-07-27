import UIKit

    // MARK: - Protocols

protocol HomeDisplayLogic: AnyObject {
    func displayContent(viewModel: HomeModels.DisplayContent.ViewModel)
    func displayMoreNews(viewModel: HomeModels.DisplayMoreNews.ViewModel)
    func displayDetail(viewModel: HomeModels.DisplayDetail.ViewModel)
}

    // MARK: - HomeViewController

final class HomeViewController: MainViewController {
    // MARK: - Public
    var interactor: HomeBusinessLogic?
    var router: (HomeRoutingLogic & HomeDataPassing)?
    
    // MARK: - Private
    private enum Constants {
        static let cellReuseIdentifier = String(describing: HomeViewController.self)
        static let prefetchRange: Int = 2
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
            forCellWithReuseIdentifier: Constants.cellReuseIdentifier
        )
        view.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
        view.delegate = self
        view.prefetchDataSource = self
        view.alwaysBounceVertical = true
        view.backgroundColor = .designSystemClear
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .designSystemWhite
        control.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.requestToFetchContent()
            }),
            for: .valueChanged
        )
        control.attributedTitle = NSMutableAttributedString(string: .refreshText)
        return control
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .designSystemDarkGray
        createSections()
        addSubviews()
        configureConstraints()
        requestToFetchContent()
    }
}

    // MARK: - HomeDisplayLogic

extension HomeViewController: HomeDisplayLogic {
    
    // MARK: Display

    func displayContent(viewModel: HomeModels.DisplayContent.ViewModel) {
        showMessageIfNeeded(viewModel.message)

        var snapshot = dataSource.snapshot()
        snapshot.appendItems(viewModel.blogs, toSection: .blog)
        snapshot.appendItems(viewModel.news, toSection: .news)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        refreshControl.endRefreshing()
    }
    
    func displayMoreNews(viewModel: HomeModels.DisplayMoreNews.ViewModel) {
        showMessageIfNeeded(viewModel.message)

        var snapshot = dataSource.snapshot()
        snapshot.appendItems(viewModel.news, toSection: .news)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        refreshControl.endRefreshing()
    }
    
    func displayDetail(viewModel: HomeModels.DisplayDetail.ViewModel) {
        showMessageIfNeeded(viewModel.message)
        router?.routeToDetail()
    }
    
    // MARK: Request
    
    private func requestToFetchContent() {
        refreshControl.beginRefreshing()
        interactor?.fetchContent(request: .init())
    }
    
    private func requestToDisplayMoreNews(offset: Int) {
        interactor?.fetchMoreNews(request: .init(offset: offset))
    }
    
    private func requestToDisplayDetail(by id: Int, for section: HomeSection) {
        interactor?.fetchSelectedDetail(request: .init(id: id, section: section))
    }
}

    // MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellConfiguration = collectionView.cellForItem(at: indexPath)?.contentConfiguration

        if let config = cellConfiguration as? NewsContentConfiguration {
            requestToDisplayDetail(by: config.id, for: HomeSection.news)
        } else if let config = cellConfiguration as? BlogContentConfiguration {
            requestToDisplayDetail(by: config.id, for: HomeSection.blog)
        }
    }
}

    // MARK: - UICollectionViewDataSourcePrefetching

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard
            let lastIndex = indexPaths.last,
            lastIndex.section == HomeSection.news.rawValue
        else {
            return
        }

        let itemsCount = dataSource.snapshot().numberOfItems(inSection: .news)
        
        guard lastIndex.row >= itemsCount - Constants.prefetchRange else {
            return
        }
        
        requestToDisplayMoreNews(offset: itemsCount)
    }
}

    // MARK: - UserInterface & DiffableDataSource

private extension HomeViewController {
    
    func addSubviews() {
        view.addSubview(collectionView)
        collectionView.refreshControl = refreshControl
    }
        
    func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
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
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, elementKind, indexPath in
            return self.makeDataSourceSupplementaryProvider(collectionView: collectionView, elementKind: elementKind, indexPath: indexPath)
        }
        return dataSource
    }
    
    func makeDataSourceSupplementaryProvider(collectionView: UICollectionView, elementKind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath
        )
        guard
            let headerView = supplementaryView as? SectionHeaderView,
            let section = HomeSection(rawValue: indexPath.section)
        else {
            return .init(frame: .zero)
        }
        headerView.configure(with: section)
        return headerView
    }
    
    func createSections() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.blog, .news])
        dataSource.apply(snapshot)
    }
}
