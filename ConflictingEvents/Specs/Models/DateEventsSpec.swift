import Quick
import Moocher
@testable import ConflictingEvents

final class DateEventsSpec: QuickSpec {
    override class func spec() {
        describe("DateEvents") {
            var subject: DateEvents!
            
            beforeEach {
                subject = DateEvents(date: "99/99/9999",
                                     events: [])
            }
            
            it("has a dateKey string") {
                expect(subject.dateKey).to.equal("99/99/9999")
            }
            
            describe("when there are no conflicts in the events array") {
                beforeEach {
                    subject.events = SpecEventDataSource.build()[0].events
                    
                    subject.updateConflictFlags()
                }
                
                it("updates the hasConflict flags appropriately for each event") {
                    expect(subject.events[0].hasConflict).to.beFalsy()
                    expect(subject.events[1].hasConflict).to.beFalsy()
                }
            }
            
            // Assumption, we mark both events in conflict if they have overlapping times
            
            describe("when there are conflicts in the events array") {
                beforeEach {
                    subject.events = SpecEventDataSource.build()[1].events
                    
                    subject.updateConflictFlags()
                }
                
                it("updates the hasConflict flags appropriately for each event") {
                    expect(subject.events[0].hasConflict).to.beTruthy()
                    expect(subject.events[1].hasConflict).to.beTruthy()
                }
            }
        }
    }
}
