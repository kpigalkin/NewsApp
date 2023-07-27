//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit

    // MARK: - Protocols

protocol DetailBusinessLogic {
    func fetchDetail(request: Detail.Display.Request)
}

protocol DetailDataStore {
    var detailContent: DetailContent? { get set }
}

    // MARK: - DetailInteractor

final class DetailInteractor: DetailDataStore {
    var presenter: DetailPresentationLogic?
    var detailContent: DetailContent?
}

    // MARK: - DetailBusinessLogic

extension DetailInteractor: DetailBusinessLogic {
    func fetchDetail(request: Detail.Display.Request) {
        guard let detailContent else { return }
        presenter?.presentDetail(response: .init(content: detailContent))
    }
}
