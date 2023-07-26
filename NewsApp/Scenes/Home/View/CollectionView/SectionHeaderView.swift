import UIKit

final class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: SectionHeaderView.self)
    // MARK: - Private
    private enum Constants {
        static let leadingSpacing: CGFloat = 28
        static let bottomSpacing: CGFloat = 11
    }
    private lazy var nameLabel = UILabel(style: .title1)
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    // MARK: - Public

extension SectionHeaderView {
    func configure(with section: HomeSection) {
        switch section {
        case .blog:
            nameLabel.text = "Latests blogs"
        case .news:
            nameLabel.text = "News"
        }
    }
}

    // MARK: - User Interface

private extension SectionHeaderView {
    func addSubviews() {
        addSubview(nameLabel)
    }
    
    func configureConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingSpacing),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bottomSpacing)
        ])
    }
}