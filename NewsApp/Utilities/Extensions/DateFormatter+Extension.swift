//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import Foundation

extension DateFormatter {
    func convertMultipleFormatDate(from fromFormats: [String],
                                   to toFormat: String,
                                   date dateString: String,
                                   localeID: String = "en_US") -> String {
        var date: Date?
        fromFormats.forEach {
            dateFormat = $0
            if let tempDate = self.date(from: dateString) {
                date = tempDate
            }
        }
        
        guard let date else { return dateString }
    
        self.dateFormat = toFormat
        self.locale = Locale(identifier: localeID)
        return self.string(from: date)
    }
}
