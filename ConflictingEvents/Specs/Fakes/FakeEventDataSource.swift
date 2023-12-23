import Foundation
@testable import ConflictingEvents

final class FakeEventDataSource: EventDataSourceProtocol {
    // MARK: - Stubbed properties
    
    var stubbedDateEvents = SpecEventDataSource.build()
    
    // MARK: - EventDataSourceProtocol
    
    func build() -> [DateEvents] {
        return stubbedDateEvents
    }
}
