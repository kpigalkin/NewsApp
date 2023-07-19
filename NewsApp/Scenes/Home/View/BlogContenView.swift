import Foundation
import UIKit
import Kingfisher

struct BlogContentConfiguration: UIContentConfiguration {
    let id: Int
    let imageURL: URL?
    let title: String
    
    func makeContentView() -> UIView & UIContentView {
        BlogContentView(with: self)
    }
    
    func updated(for state: UIConfigurationState) -> BlogContentConfiguration {
        self
    }
}

final class BlogContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            configure()
        }
    }
    
    private enum Constants {
        static let heightPadding: CGFloat = 25
        static let imageSizeMultiplier: CGFloat = 0.17
        static let titleLinesCount: Int = 1
        static let padding: CGFloat = 18
        static let cornerRadius: CGFloat = 12
    }
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private var titleLabel = UILabel(style: .body, linesCount: Constants.titleLinesCount)
            
    init(with contentConfiguration: BlogContentConfiguration) {
        configuration = contentConfiguration
        super.init(frame: .zero)
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BlogContentView {
    func configure() {
        guard let content = configuration as? BlogContentConfiguration else { return }
        imageView.kf.setImage(with: content.imageURL, targetWidth: .smallPreview)
        titleLabel.text = content.title
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    func configureConstraints() {
        [
            imageView,
            titleLabel,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.imageSizeMultiplier),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.imageSizeMultiplier),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.heightPadding),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.heightPadding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.heightPadding),
        ])
    }
}
