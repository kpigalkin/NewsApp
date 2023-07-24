import UIKit

protocol DetailPresentationLogic {
    func presentDetail(response: Detail.Display.Response)
}

final class DetailPresenter {
    weak var viewController: DetailDisplayLogic?
}

extension DetailPresenter: DetailPresentationLogic {
    func presentDetail(response: Detail.Display.Response) {
        if let blog = response.content.blog {
            viewController?.displayDetail(viewModel: .init(
                id: blog.id,
                url: URL(string: blog.url),
                imageURL: URL(string: blog.imageURL),
                title: blog.title,
                summary: blog.summary,
                publishDate: convertDate(from: blog.date)
            ))
        } else if let news = response.content.news {
            viewController?.displayDetail(viewModel: .init(
                id: news.id,
                url: URL(string: news.url),
                imageURL: URL(string: news.imageURL),
                title: news.title,
                summary: news.summary,
                publishDate: convertDate(from: news.date)
            ))
        }
    }
}

private extension DetailPresenter {
    func convertDate(from stringDate: String) -> String  {
        return DateFormatter().convertMultipleFormatDate(
            formats: SpaceFlightNewsEndpoint.dateFormats,
            from: stringDate,
            toFormat: AppConstants.DateFormat.presentingFormat.rawValue
        )
    }
}
