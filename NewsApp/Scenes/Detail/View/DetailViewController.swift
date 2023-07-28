//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit
import Kingfisher

    // MARK: - Protocols

protocol DetailDisplayLogic: AnyObject {
    func displayDetail(viewModel: Detail.Display.ViewModel)
}

    // MARK: - DetailViewController

final class DetailViewController: UIViewController {
    static let cellReuseIdentifier = String(describing: DetailViewController.self)

    // MARK: - Public
    
    var interactor: DetailBusinessLogic?
    var router: (DetailRoutingLogic & DetailDataPassing)?
    
    // MARK: - Private
    
    private enum Constants {
        static let animationDuration: CGFloat = 0.5
        static let aspectRatio: CGFloat = 10 / 16
        static let heightPadding: CGFloat = 25
        static let cornerRadius: CGFloat = 20
        static let padding: CGFloat = 10
    }
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = Constants.heightPadding
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private lazy var titleLabel = UILabel(style: .title1)
    
    private lazy var summaryLabel = UILabel(style: .body)
    
    private lazy var linkTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isSelectable = true
        return textView
    }()
    
    private lazy var dateLabel = UILabel(style: .footnote)
            
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        configureConstraints()
        interactor?.fetchDetail(request: .init())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeImageView()
    }
}

    // MARK: - DetailDisplayLogic

extension DetailViewController: DetailDisplayLogic {
        
    func displayDetail(viewModel: Detail.Display.ViewModel) {
        imageView.kf.setImage(with: viewModel.imageURL, targetWidth: .full)
        linkTextView.attributedText = createLink(from: viewModel.url)
        dateLabel.text = viewModel.publishDate
        summaryLabel.text = viewModel.summary
        titleLabel.text = viewModel.title
    }
}

    // MARK: - User Interface

private extension DetailViewController {
    func setupView() {
        sheetPresentationController?.detents = [.medium(), .large()]
        view.backgroundColor = .DesignSystem.darkGray
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(summaryLabel)
        stackView.addArrangedSubview(linkTextView)
        stackView.addArrangedSubview(dateLabel)
    }
    
    func configureConstraints() {
        [
            scrollView,
            stackView,
            imageView,
            titleLabel,
            summaryLabel,
            linkTextView,
            dateLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.heightPadding),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.heightPadding),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.heightPadding),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.heightPadding),
           
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
    
    func resizeImageView() {
        guard let image = imageView.image else { return }
        
        UIView.animate(withDuration: Constants.animationDuration, delay: .zero) {
            self.stackView.layoutIfNeeded()
            let width = self.stackView.bounds.width
            
            self.imageView.heightConstraint?.constant = image.aspectRatio * width
            self.imageView.layoutIfNeeded()
        }
    }
        
    func createLink(from url: URL?) -> NSMutableAttributedString? {
        guard let url else { return nil }
        
        let attributedString = NSMutableAttributedString(string: url.absoluteString)
        attributedString.addAttributes(
            [
                NSAttributedString.Key.link : url,
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body)
            ],
            range: NSRange(.zero...url.absoluteString.count - 1)
        )
        
        return attributedString
    }
}
