import Foundation
@testable import ConflictingEvents

final class FakeJSONLoader: JSONLoaderProtocol {
    var stubbedBuildEvents = {
        let eventDataSource = SpecEventDataSource.build()
        
        let events = eventDataSource.map { dateEvent in
            return dateEvent.events
        }.flatMap { event in
            return event
        }
        
        return events
    }()
    
    // MARK: - JSONLoaderProtocol
    
    func buildEvents() -> [ConflictingEvents.Event] {
        return stubbedBuildEvents
    }
}
