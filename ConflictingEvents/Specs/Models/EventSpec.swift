import Quick
import Moocher
@testable import ConflictingEvents

final class EventSpec: QuickSpec {
    override class func spec() {
        describe("Event") {
            var subject: Event!
                        
            beforeEach {
                subject = Event(title: "Breakfast w/ George McFly",
                                startDate: SpecEventDataSource.buildDate(dateString: "11/06/1955 8:00 AM"),
                                startJSONDateString: "November 6, 1955 8:00 AM",
                                startTimeOnlyString: "8:00 AM",
                                startDateOnlyString: "11/06/1955",
                                endDate: SpecEventDataSource.buildDate(dateString: "11/06/1955 9:00 AM"),
                                endDateJSONString: "November 6, 1955 9:00 AM",
                                endTimeOnlyString: "9:00 AM")
            }
            
            it("has a title") {
                expect(subject.title).to.equal("Breakfast w/ George McFly")
            }
            
            it("has a startDate") {
                expect(subject.startDate).to.equal(SpecEventDataSource.buildDate(dateString: "11/06/1955 8:00 AM"))
            }
            
            it("has a startJSONDateString") {
                expect(subject.startJSONDateString).to.equal("November 6, 1955 8:00 AM")
            }
            
            it("has a startTimeOnlyString") {
                expect(subject.startTimeOnlyString).to.equal("8:00 AM")
            }
            
            it("has a startDateOnlyString") {
                expect(subject.startDateOnlyString).to.equal("11/06/1955")
            }
            
            it("has a endDate") {
                expect(subject.endDate).to.equal(SpecEventDataSource.buildDate(dateString: "11/06/1955 9:00 AM"))
            }
            
            it("has a endDateJSONString") {
                expect(subject.endDateJSONString).to.equal("November 6, 1955 9:00 AM")
            }
            
            it("has a endTimeOnlyString") {
                expect(subject.endTimeOnlyString).to.equal("9:00 AM")
            }
            
            it("has a hasConflict flag that defaults to false") {
                expect(subject.hasConflict).to.beFalsy()
            }
            
            describe("<Codable>") {
                describe("the 'custom' CodingKeys") {
                    expect(Event.CodingKeys.startDate.rawValue).to.equal("start")
                    expect(Event.CodingKeys.endDate.rawValue).to.equal("end")
                }
            }
            
            describe("<CustomStringConvertable>") {
                describe("#description") {
                    it("is given properly") {
                        let expectedDescription = "Event(title: \(subject.title), startDate: \(subject.startJSONDateString), endDate: \(subject.endDateJSONString), hasConflict: \(subject.hasConflict))"
                        
                        expect(subject.description).to.equal(expectedDescription)
                    }
                }
            }
            
            describe("<Comparable>") {
                describe("<") {
                    it("it is comparable by startDate only") {
                        var anotherEvent = subject!
                        
                        anotherEvent.startDate = SpecEventDataSource.buildDate(dateString: "11/06/1000 8:00 AM")
                        
                        expect(anotherEvent).to.beLessThan(subject)
                    }
                }
            }
        }
    }
}
