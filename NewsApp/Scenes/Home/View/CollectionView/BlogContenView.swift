//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import Foundation
import UIKit
import Kingfisher

    // MARK: - BlogContentConfiguration

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

    // MARK: - BlogContentView

final class BlogContentView: UIView, UIContentView {
    
    // MARK: - Public
    
    var configuration: UIContentConfiguration {
        didSet {
            configure()
        }
    }
    
    // MARK: - Private
    
    private enum Constants {
        static let bigSpacing: CGFloat = 25
        static let spacing: CGFloat = 12

        static let imageSide: CGFloat = 70
        static let titleLinesCount: Int = 1
        static let cornerRadius: CGFloat = 12
    }
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .DesignSystem.gray
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private var titleLabel = UILabel(style: .body, linesCount: Constants.titleLinesCount)
    
    // MARK: - Lifecycle

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

    // MARK: - User Interface

private extension BlogContentView {
    func configure() {
        guard let content = configuration as? BlogContentConfiguration else { return }
        imageView.kf.setImage(with: content.imageURL, targetWidth: .preview)
        titleLabel.text = content.title
    }
    
    func addSubviews() {
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    func configureConstraints() {
        [
            backgroundView,
            imageView,
            titleLabel,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSide),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSide),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.bigSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.bigSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bigSpacing),
            
            backgroundView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -Constants.spacing),
            backgroundView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -Constants.spacing),
            backgroundView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.spacing),
            backgroundView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.spacing)
        ])
    }
}
