//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import Foundation
import UIKit
import Kingfisher

    // MARK: - NewsContentConfiguration

struct NewsContentConfiguration: UIContentConfiguration {
    let id: Int
    let imageURL: URL?
    let title, date: String
    
    func makeContentView() -> UIView & UIContentView {
        NewsContentView(with: self)
    }
    
    func updated(for state: UIConfigurationState) -> NewsContentConfiguration {
        self
    }
}

    // MARK: - NewsContentView

final class NewsContentView: UIView, UIContentView {
    
    // MARK: - Public
    
    var configuration: UIContentConfiguration {
        didSet {
            configure()
        }
    }
    
    // MARK: - Private
    
    private enum Constants {
        static let aspectRatio: CGFloat = 11 / 16
        static let summaryLinesCount: Int = 2
        static let cornerRadius: CGFloat = 20
        static let bigSpacing: CGFloat = 16
        static let spacing: CGFloat = 8
    }
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .DesignSystem.gray
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private var titleLabel = UILabel(style: .title2)

    private var dateLabel: UILabel = {
        let label = UILabel(style: .callout)
        label.textAlignment = .right
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private var textStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.spacing = Constants.spacing
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()
    
    // MARK: - Lifecycle
    
    init(with contentConfiguration: NewsContentConfiguration) {
        configuration = contentConfiguration
        super.init(frame: .zero)
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    // MARK: - User Interface

private extension NewsContentView {
    func configure() {
        guard let content = configuration as? NewsContentConfiguration else { return }
        imageView.kf.setImage(with: content.imageURL, targetWidth: .full)
        titleLabel.text = content.title
        dateLabel.text = content.date
    }
    
    func addSubviews() {
        addSubview(backgroundView)
        addSubview(imageView)
        addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(dateLabel)
    }
    
    func configureConstraints() {
        [
            imageView,
            textStackView,
            titleLabel,
            dateLabel,
            backgroundView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.aspectRatio),

            textStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.bigSpacing),
            textStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: Constants.bigSpacing),
            textStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -Constants.bigSpacing),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.spacing),
            
            backgroundView.topAnchor.constraint(equalTo: imageView.centerYAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
