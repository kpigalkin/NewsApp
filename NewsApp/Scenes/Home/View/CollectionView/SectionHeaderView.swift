//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: SectionHeaderView.self)
    // MARK: - Private
    private enum Constants {
        static let leadingSpacing: CGFloat = 28
        static let bottomSpacing: CGFloat = 11
        static let cornerRadius: CGFloat = 14
    }
    private lazy var nameLabel = UILabel(style: .title1)
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
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
        nameLabel.text = section.name
    }
}

    // MARK: - User Interface

private extension SectionHeaderView {
    func setupView() {
        backgroundColor = .designSystemDarkGray
        layer.cornerRadius = Constants.cornerRadius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
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
