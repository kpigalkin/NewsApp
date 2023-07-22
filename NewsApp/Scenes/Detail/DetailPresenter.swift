import UIKit

protocol DetailPresentationLogic {
    func presentDetail(response: Detail.Display.Response)
}

final class DetailPresenter {
    weak var viewController: DetailDisplayLogic?
}

extension DetailPresenter: DetailPresentationLogic {
    func presentDetail(response: Detail.Display.Response) {
        let viewModel = Detail.Display.ViewModel(
            id: response.element.id,
            url: URL(string: response.element.url),
            imageURL: URL(string: response.element.imageURL),
            title: response.element.title,
            summary: response.element.summary,
            publishDate: DateFormatter().convertMultipleFormatDate(
                formats: SpaceFlightNewsEndpoint.dateFormats,
                from: response.element.date,
                toFormat: AppConstants.DateFormat.presentingFormat.rawValue
            )
        )
        viewController?.displayDetail(viewModel: viewModel)
    }
}
