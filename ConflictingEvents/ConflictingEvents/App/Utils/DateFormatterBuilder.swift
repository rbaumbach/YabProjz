import Foundation

final class DateFormatterBuilder {
    static let eventJSONFormat = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy hh:mm a"
        
        return dateFormatter
    }()
    
    static let eventTimeOnlyFormat = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter
    }()
    
    static let eventDateOnlyFormat = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter
    }()
}
