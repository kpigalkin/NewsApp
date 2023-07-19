import UIKit
import Kingfisher

protocol DetailDisplayLogic: AnyObject {
    func displayDetail(viewModel: Detail.Display.ViewModel)
}

final class DetailViewController: UIViewController {
    static let cellReuseIdentifier = String(describing: DetailViewController.self)

    // MARK: - Public
    
    var interactor: DetailBusinessLogic?
    var router: (DetailRoutingLogic & DetailDataPassing)?
    
    // MARK: - Private
    
    private enum Constants {
        static let aspectRatio: CGFloat = 10 / 16
        static let heightPadding: CGFloat = 25
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
        view.backgroundColor = .systemGray5
        addSubviews()
        configureConstraints()
        requestToFetchDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeImageView()
    }
}

extension DetailViewController: DetailDisplayLogic {

    // MARK: - Display
    
    func displayDetail(viewModel: Detail.Display.ViewModel) {
        imageView.kf.setImage(with: viewModel.imageURL)
        linkTextView.attributedText = createLink(from: viewModel.url)
        dateLabel.text = viewModel.publishDate
        summaryLabel.text = viewModel.summary
        titleLabel.text = viewModel.title
    }
    
    // MARK: - Request
    
    private func requestToFetchDetail() {
        interactor?.fetchDetail(request: .init())
    }
}

private extension DetailViewController {
    
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

        stackView.layoutIfNeeded()
        let width = stackView.bounds.width
        
        imageView.heightConstraint?.constant = image.aspectRatio * width
        imageView.layoutIfNeeded()
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
