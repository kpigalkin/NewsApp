import Foundation
import UIKit
import Kingfisher

struct NewsListContentConfiguration: UIContentConfiguration {
    let id: Int
    let url: String
    let imageURL: URL?
    let title, summary, date: String
    
    func makeContentView() -> UIView & UIContentView {
        NewsListContentView(with: self)
    }
    
    func updated(for state: UIConfigurationState) -> NewsListContentConfiguration {
        self
    }
}

final class NewsListContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            configure()
        }
    }
    
    private enum Constants {
        static let summaryLinesCount: Int = 3
    }
    
    private var titleLabel = UILabel(style: .title2)
    private var summaryLabel = UILabel(style: .body, linesCount: Constants.summaryLinesCount)
    private var dateLabel = UILabel(style: .footnote)
    private var imageView = UIImageView()
    
    private var textStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.spacing = LayoutConstants.padding
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()
    
    init(with contentConfiguration: NewsListContentConfiguration) {
        configuration = contentConfiguration
        super.init(frame: .infinite)
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewsListContentView {
    func configure() {
        guard let content = configuration as? NewsListContentConfiguration else { return }
        imageView.kf.setImage(with: content.imageURL)
        summaryLabel.text = content.summary
        titleLabel.text = content.title
        dateLabel.text = content.date
    }
    
    func addSubviews() {
        [ imageView, textStackView ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        [ titleLabel, summaryLabel, dateLabel ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            textStackView.addArrangedSubview($0)
        }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.padding),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstants.padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: LayoutConstants.aspectRatio),

            textStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LayoutConstants.padding),
            textStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            textStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

