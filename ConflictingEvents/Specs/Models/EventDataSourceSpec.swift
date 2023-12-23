import Quick
import Moocher
@testable import ConflictingEvents

final class EventDataSourceSpec: QuickSpec {
    override class func spec() {
        describe("EventDataSource") {
            var subject: EventDataSource!
            
            var fakeJSONLoader: FakeJSONLoader!
            
            beforeEach {
                fakeJSONLoader = FakeJSONLoader()
                
                subject = EventDataSource(jsonLoader: fakeJSONLoader)
            }
            
            describe("#build()") {
                var dateEvents: [DateEvents]!
                
                beforeEach {
                    dateEvents = subject.build()
                }
                
                it("loads all events from JSON and builds an array of sorted DateEvents") {
                    // Verify events without conflicts
                    
                    expect(dateEvents[0].events[0].hasConflict).to.beFalsy()
                    expect(dateEvents[0].events[1].hasConflict).to.beFalsy()
                    
                    // Verify events with conflicts
                    
                    expect(dateEvents[1].events[0].hasConflict).to.beTruthy()
                    expect(dateEvents[1].events[1].hasConflict).to.beTruthy()
                }
            }
        }
    }
}
