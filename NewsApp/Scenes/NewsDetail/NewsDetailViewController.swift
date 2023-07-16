import UIKit
import Kingfisher

protocol NewsDetailDisplayLogic: AnyObject {
    func displayNewsDetail(viewModel: NewsDetail.ShowElement.ViewModel)
}

final class NewsDetailViewController: UIViewController {
    static let cellReuseIdentifier = "detailTableViewCell"

    // MARK: - Public
    
    var interactor: NewsDetailBusinessLogic?
    var router: (NewsDetailsRoutingLogic & NewsDetailsDataPassing)?
    
    // MARK: - Private
    
    private lazy var scrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = LayoutConstants.heightPadding
        return stackView
    }()
    private lazy var imageView = UIImageView()
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
        view.backgroundColor = .systemGray5
        addSubviews()
        configureConstraints()
        requestToFetchNewsDetail()
    }
}

extension NewsDetailViewController: NewsDetailDisplayLogic {

    // MARK: - Display
    
    func displayNewsDetail(viewModel: NewsDetail.ShowElement.ViewModel) {
        linkTextView.attributedText = createLink(from: viewModel.url)
        imageView.kf.setImage(with: viewModel.imageURL)
        dateLabel.text = viewModel.publishDate
        summaryLabel.text = viewModel.summary
        titleLabel.text = viewModel.title
    }
    
    // MARK: - Request
    
    private func requestToFetchNewsDetail() {
        interactor?.fetchNewsDetail(request: .init())
    }
}

private extension NewsDetailViewController {
    
    // MARK: - Subviews & Constraints

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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.heightPadding),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.padding),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.padding),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -LayoutConstants.heightPadding),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: LayoutConstants.heightPadding),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -LayoutConstants.heightPadding),
            
            imageView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: LayoutConstants.aspectRatio)
        ])
    }
    
    // MARK: - Link
    
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
