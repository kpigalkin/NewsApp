import Foundation
import UIKit

struct NewsContentConfiguration: UIContentConfiguration {
    let id: Int
    let title, url, imageURL: String
    let summary, date: String
    
    func makeContentView() -> UIView & UIContentView {
        NewsContentView(with: self)
    }
    
    func updated(for state: UIConfigurationState) -> NewsContentConfiguration {
        self
    }
}

final class NewsContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            configureContent()
        }
    }
    
    private enum Constants {
        static let saveButtonSizeMultiplier: CGFloat = 0.2
        static let aspectRatio: CGFloat = 10 / 16
        static let imagePointSize: CGFloat = 25
        static let cornerRadius: CGFloat = 9
        static let padding: CGFloat = 10
        static let spacing: CGFloat = 8
        static let titleFont: UIFont = .systemFont(ofSize: 19, weight: .bold)
        static let dateFont: UIFont = .systemFont(ofSize: 14, weight: .semibold)
        static let summaryFont: UIFont = .systemFont(ofSize: 15, weight: .semibold)
        static let summaryVisibleLinesCount: Int = 1
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.font = Constants.titleFont
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.font = Constants.summaryFont
        label.numberOfLines = Constants.summaryVisibleLinesCount
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.dateFont
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .brown
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var summaryStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.contentMode = .left
        view.spacing = Constants.spacing
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: AppImage.saveButton)?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.setPreferredSymbolConfiguration(
            .init(pointSize: Constants.imagePointSize, weight: .semibold, scale: .large),
            forImageIn: .normal
        )
        return button
    }()
    
    init(with contentConfiguration: NewsContentConfiguration) {
        configuration = contentConfiguration
        super.init(frame: .infinite)
        addSubviews()
        configureConstraints()
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewsContentView {
    var aspectRatio: CGFloat {
        guard let size = imageView.image?.size else { return Constants.aspectRatio }
        return size.height / size.width
    }
    
    func configureContent() {
        guard let content = configuration as? NewsContentConfiguration else { return }
        summaryLabel.text = content.summary
        titleLabel.text = content.title
        dateLabel.text = content.date
        imageView.image = UIImage(named: "default-image")
    }
    
    func addSubviews() {
        [
            imageView,
            summaryStackView,
            saveButton,
            titleLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        [summaryLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            summaryStackView.addArrangedSubview($0)
        }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.spacing),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

            summaryStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            summaryStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            summaryStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            summaryStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            saveButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -Constants.padding),
            saveButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: Constants.padding),
        ])
    }
}

