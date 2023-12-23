import Foundation

struct Event: Codable, CustomStringConvertible, Comparable, Equatable {
    // MARK: - Public properties
    
    var title: String
    
    var startDate: Date
    var startJSONDateString: String
    var startTimeOnlyString: String
    var startDateOnlyString: String
    
    var endDate: Date
    var endDateJSONString: String
    var endTimeOnlyString: String
    
    var hasConflict: Bool = false
    
    // MARK: - Init methods
    
    init(title: String, startDate: Date, startJSONDateString: String,
         startTimeOnlyString: String, startDateOnlyString: String, endDate: Date,
         endDateJSONString: String, endTimeOnlyString: String) {
        self.title = title
        self.startDate = startDate
        self.startJSONDateString = startJSONDateString
        self.startTimeOnlyString = startTimeOnlyString
        self.startDateOnlyString = startDateOnlyString
        self.endDate = endDate
        self.endDateJSONString = endDateJSONString
        self.endTimeOnlyString = endTimeOnlyString
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        
        // Assumption: make startDate "now" if the start/endDate json is malformed
        
        startJSONDateString = try container.decode(String.self, forKey: .startDate)
        startDate = DateFormatterBuilder.eventJSONFormat.date(from: startJSONDateString) ?? Date()
        startTimeOnlyString = DateFormatterBuilder.eventTimeOnlyFormat.string(from: startDate)
        startDateOnlyString = DateFormatterBuilder.eventDateOnlyFormat.string(from: startDate)
        
        endDateJSONString = try container.decode(String.self, forKey: .endDate)
        endDate = DateFormatterBuilder.eventJSONFormat.date(from: endDateJSONString) ?? Date()
        endTimeOnlyString = DateFormatterBuilder.eventTimeOnlyFormat.string(from: endDate)
    }
    
    // MARK: - <Codable>
    
    enum CodingKeys: String, CodingKey {
        case title
        case startDate = "start"
        case endDate = "end"
    }
    
    // MARK: - <CustomStringConvertible>
    
    var description: String {
        return "Event(title: \(title), startDate: \(startJSONDateString), endDate: \(endDateJSONString), hasConflict: \(hasConflict))"
    }
    
    // MARK: - <Comparable>
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.startDate < rhs.startDate
    }
}
