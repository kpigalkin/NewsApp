import Foundation
import UIKit
import Kingfisher

struct NewsContentConfiguration: UIContentConfiguration {
    let id: Int
    let url: String
    let imageURL: URL?
    let title, summary, date: String
    
    func makeContentView() -> UIView & UIContentView {
        NewsContentView(with: self)
    }
    
    func updated(for state: UIConfigurationState) -> NewsContentConfiguration {
        self
    }
}

final class NewsContentView: UIView, UIContentView {
    private enum Constants {
        static let aspectRatio: CGFloat = 10 / 16
        static let summaryNumberOfLines: Int = 1
        static let cornerRadius: CGFloat = 9
        static let padding: CGFloat = 10
        static let spacing: CGFloat = 8
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private var summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private var dateLabel = UILabel()
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private var summaryStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.contentMode = .left
        view.spacing = Constants.spacing
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()
    
    init(with contentConfiguration: NewsContentConfiguration) {
        configuration = contentConfiguration
        super.init(frame: .infinite)
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            configure()
        }
    }
}

private extension NewsContentView {
    var aspectRatio: CGFloat {
        guard let size = imageView.image?.size else { return Constants.aspectRatio }
        return size.height / size.width
    }
    
    func configure() {
        guard let content = configuration as? NewsContentConfiguration else { return }
        imageView.kf.setImage(with: content.imageURL, options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
        summaryLabel.text = content.summary
        titleLabel.text = content.title
        dateLabel.text = content.date
    }
    
    func addSubviews() {
        [ imageView, summaryStackView, titleLabel ]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        [summaryLabel, dateLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                summaryStackView.addArrangedSubview($0)
            }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            summaryStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            summaryStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            summaryStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            summaryStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

