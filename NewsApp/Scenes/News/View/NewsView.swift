import UIKit

enum SectionType: Int {
    case news
}

final class NewsView: UIView {
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<SectionType, NewsCollectionItem>
    weak var viewController: NewsViewEvents?
    
    static let cellIdentifier = "cell"
    
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, NewsContentConfiguration> { cell, indexPath, configuration in
        cell.contentConfiguration = nil
        cell.contentConfiguration = configuration
    }
    
    private lazy var dataSource = makeDataSource()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: NewsCollectionViewLayoutFactory.newsFeedLayout()
        )
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NewsView.cellIdentifier)
        view.delegate = self
        view.backgroundColor = .lightGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        createSections()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewsView {
    func makeDataSource() -> DiffableDataSource {
        let dataSource = DiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
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
    
    func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func createSections() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.news])
        dataSource.apply(snapshot)
    }
}

extension NewsView: NewsDisplayLogic {
    func displayNews(viewModel: News.Latest.ViewModel) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(viewModel.newsItems, toSection: .news)
        dataSource.apply(snapshot)
    }
}

extension NewsView: UICollectionViewDelegate {}
