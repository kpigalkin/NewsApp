import Foundation

extension DateFormatter {
    func convertMultipleFormatDate(formats: [String], from dateString: String, toFormat: String) -> String {
        var date: Date?
        formats.forEach {
            dateFormat = $0
            if let tempDate = self.date(from: dateString) {
                date = tempDate
            }
        }
        
        guard let date else { return dateString }
    
        dateFormat = toFormat
        locale = Locale(identifier: "en_US")
        return self.string(from: date)
    }
}
