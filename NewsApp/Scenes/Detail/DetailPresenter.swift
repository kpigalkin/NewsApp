import UIKit

    // MARK: - Protocols

protocol DetailPresentationLogic {
    func presentDetail(response: Detail.Display.Response)
}

    // MARK: - DetailPresenter

final class DetailPresenter {
    weak var viewController: DetailDisplayLogic?
}

    // MARK: - DetailPresentationLogic

extension DetailPresenter: DetailPresentationLogic {
    func presentDetail(response: Detail.Display.Response) {
        if let blog = response.content.blog {
            viewController?.displayDetail(viewModel: .init(
                id: blog.id,
                url: URL(string: blog.url),
                imageURL: URL(string: blog.imageURL),
                title: blog.title,
                summary: blog.summary,
                publishDate: convertDate(blog.date)
            ))
        } else if let news = response.content.news {
            viewController?.displayDetail(viewModel: .init(
                id: news.id,
                url: URL(string: news.url),
                imageURL: URL(string: news.imageURL),
                title: news.title,
                summary: news.summary,
                publishDate: convertDate(news.date)
            ))
        }
    }
}

    // MARK: - Private

private extension DetailPresenter {
    func convertDate(_ stringDate: String) -> String  {
        return DateFormatter().convertMultipleFormatDate(
            from: SpaceFlightNewsEndpoint.dateFormats,
            to: AppConstants.DateFormat.toFormat,
            date: stringDate
        )
    }
}
