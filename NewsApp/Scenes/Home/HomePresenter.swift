//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit

    // MARK: - Protocols

protocol HomePresentationLogic {
    func presentContent(response: HomeModels.DisplayContent.Response)
    func presentMoreNews(response: HomeModels.DisplayMoreNews.Response)
    func presentDetail(response: HomeModels.DisplayDetail.Response)
}

    // MARK: - HomePresenter

final class HomePresenter {
    weak var viewController: HomeDisplayLogic?
}

    // MARK: - HomePresentationLogic

extension HomePresenter: HomePresentationLogic {

    func presentContent(response: HomeModels.DisplayContent.Response) {
        viewController?.displayContent(viewModel: .init(
            news: convertNews(response.news),
            blogs: convertBlogs(response.blogs),
            message: convertErrorToMessage(response.error, success: response.success)
        ))
    }
    
    func presentMoreNews(response: HomeModels.DisplayMoreNews.Response) {
        viewController?.displayMoreNews(viewModel: .init(
            news: convertNews(response.news),
            message: convertErrorToMessage(response.error, success: response.success)
        ))
    }
    
    func presentDetail(response: HomeModels.DisplayDetail.Response) {
        viewController?.displayDetail(viewModel: .init(
            message: convertErrorToMessage(response.error, success: response.success)
        ))
    }
}

    // MARK: - Private

private extension HomePresenter {
    
    func convertNews(_ items: [News]?) -> [HomeCollectionItem] {
        guard let items else { return [] }
        return items
            .sorted {
                $0.date > $1.date
            }
            .map {
                HomeCollectionItem(content: .news(configuration: .init(
                    id: $0.id,
                    imageURL: URL(string: $0.imageURL),
                    title: $0.title,
                    date: convertDate($0.date)
                )))
            }
    }
    
    func convertBlogs(_ items: [Blog]?) -> [HomeCollectionItem] {
        guard let items else { return [] }
        return items
            .sorted {
                $0.date > $1.date
            }
            .map {
                HomeCollectionItem(content: .blog(configuration: .init(
                    id: $0.id,
                    imageURL: URL(string: $0.imageURL),
                    title: $0.title
                )))
        }
    }
    
    func convertDate(_ stringDate: String) -> String  {
        return DateFormatter().convertMultipleFormatDate(
            from: SpaceFlightNewsEndpoint.dateFormats,
            to: DateFormatter.toFormat,
            date: stringDate
        )
    }
    
    func convertErrorToMessage(_ error: ResponseError?, success: Bool) -> Message {
        guard let error else {
            return .init(result: .success)
        }

        guard success else {
            return .init(
                result: .completeError,
                image: .remove,
                errorTitle: error.description
            )
        }
        
        let explanation: String = error is RequestError ? .storageSuccess : .requestSuccess
        
        return .init(
            result: .handeledError,
            image: .checkmark,
            errorTitle: error.description + ". " + explanation
        )
    }
}
