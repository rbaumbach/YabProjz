import Foundation

protocol EventDataSourceProtocol {
    func build() -> [DateEvents]
}

final class EventDataSource: EventDataSourceProtocol {
    // MARK: - Private properties
    
    private let jsonLoader: JSONLoaderProtocol
    
    // MARK: - Init methods
    
    init(jsonLoader: JSONLoaderProtocol = JSONLoader()) {
        self.jsonLoader = jsonLoader
    }
    
    // MARK: - Public properties
    
    func build() -> [DateEvents] {
        let eventData = jsonLoader.buildEvents()
                
        let sortedEventData = eventData.sorted { $0 < $1 }

        let result = buildAndProcessSortedEvents(sortedEvents: sortedEventData)
                
        return result
    }
    
    // MARK: - Private methods
    
    private func buildAndProcessSortedEvents(sortedEvents: [Event]) -> [DateEvents] {
        var dateEvents: [DateEvents] = []
        
        sortedEvents.forEach { event in
            if let preexistingDateEvent = dateEvents.first(where: { $0.dateKey == event.startDateOnlyString }) {
                preexistingDateEvent.events.append(event)
            } else {
                let dateEvent = DateEvents(date: event.startDateOnlyString,
                                           events: [event])
                
                dateEvents.append(dateEvent)
            }
        }
        
        dateEvents.forEach { dateEvent in
            dateEvent.updateConflictFlags()
        }
        
        return dateEvents
    }
}
