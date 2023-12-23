import Foundation

final class DateEvents: Equatable {
    // MARK: - Readonly properties
    
    let dateKey: String
    
    // MARK: - Public properties
    
    var events: [Event]
    
    // MARK: - Init methods
    
    init(date: String, events: [Event]) {
        self.dateKey = date
        self.events = events
    }
    
    // MARK: - Equatable
    
    static func == (lhs: DateEvents, rhs: DateEvents) -> Bool {
        return lhs.dateKey == rhs.dateKey && lhs.events == rhs.events
    }
    
    // MARK: - Public methods
    
    func updateConflictFlags() {
        guard !events.isEmpty else { return }
        
        var eventConflictDetectionArray = [Bool](repeating: false, count: events.count)
        var maxEndIndex = 0
        
        for index in 1..<events.count {
            if events[index].startDate < events[maxEndIndex].endDate {
                eventConflictDetectionArray[index] = true
                eventConflictDetectionArray[maxEndIndex] = true
            } else {
                maxEndIndex = index
            }
        }
        
        for index in 0..<events.count {
            events[index].hasConflict = eventConflictDetectionArray[index]
        }
    }
}
