import Foundation
import UIKit
import Kingfisher

    // MARK: - NewsContentConfiguration

struct NewsContentConfiguration: UIContentConfiguration {
    let id: Int
    let imageURL: URL?
    let title, summary, date: String
    
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
        static let aspectRatio: CGFloat = 10 / 16
        static let summaryLinesCount: Int = 3
        static let padding: CGFloat = 10
    }
    
    private var titleLabel = UILabel(style: .title2)
    private var summaryLabel = UILabel(style: .body, linesCount: Constants.summaryLinesCount)
    private var dateLabel = UILabel(style: .footnote)
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var textStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.spacing = Constants.padding
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
        imageView.kf.setImage(with: content.imageURL, targetWidth: .preview)
        summaryLabel.text = content.summary
        titleLabel.text = content.title
        dateLabel.text = content.date
    }
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(summaryLabel)
        textStackView.addArrangedSubview(dateLabel)
    }
    
    func configureConstraints() {
        [
            imageView,
            textStackView,
            titleLabel,
            summaryLabel,
            dateLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Constants.aspectRatio),

            textStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.padding),
            textStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            textStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
