import UIKit

protocol NewsDetailPresentationLogic {
    func presentNewsDetail(response: NewsDetail.ShowElement.Response)
}

final class NewsDetailPresenter {
    weak var viewController: NewsDetailDisplayLogic?
    
    private let toDateFormat = "MMM d, h:mm a"
}

extension NewsDetailPresenter: NewsDetailPresentationLogic {
    func presentNewsDetail(response: NewsDetail.ShowElement.Response) {
        let viewModel = NewsDetail.ShowElement.ViewModel(
            id: response.element.id,
            url: URL(string: response.element.url),
            imageURL: URL(string: response.element.imageURL),
            title: response.element.title,
            summary: response.element.summary,
            publishDate: DateFormatter().convertMultipleFormatDate(
                formats: SpaceFlightNewsAPI.dateFormats,
                from: response.element.publishedAt,
                toFormat: toDateFormat
            )
        )
        viewController?.displayNewsDetail(viewModel: viewModel)
    }
}
