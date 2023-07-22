import Foundation

extension DateFormatter {
    func convertMultipleFormatDate(formats: [String],
                                   from dateString: String,
                                   toFormat: String,
                                   localeID: String = "en_US") -> String {
        var date: Date?
        formats.forEach {
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
