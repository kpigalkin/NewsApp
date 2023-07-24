import Foundation

extension DateFormatter {
    func convertMultipleFormatDate(from fromFormats: [String],
                                   to toFormat: String,
                                   date dateString: String,
                                   localeID: String = "en_US") -> String {
        var date: Date?
        from fromFormats.forEach {
            dateFormat = $0
            if let tempDate = self.date(from: dateString) {
                date = tempDate
            }
        }
        
        guard let date else { return dateString }
    
        self.dateFormat = to toFormat
        self.locale = Locale(identifier: localeID)
        return self.string(from: date)
    }
}
