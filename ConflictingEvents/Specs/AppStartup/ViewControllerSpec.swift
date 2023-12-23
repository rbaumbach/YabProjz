import Quick
import Moocher
@testable import ConflictingEvents

final class ViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("ViewController") {
            var subject: ViewController!
            
            var fakeEventDataSource: FakeEventDataSource!
            
            beforeEach {
                subject = ViewControllerBuilder().build(name: "Main")
                
                fakeEventDataSource = FakeEventDataSource()
                
                subject.eventDataSource = fakeEventDataSource
            }
            
            it("has an empty dataSource") {
                expect(subject.dataSource).to.beEmpty()
            }
            
            describe("when the view loads") {
                beforeEach {
                    _ = subject.view
                }
                
                describe("<UITableViewDataSource>") {
                    describe("#numberOfSections(in:)") {
                        var numberOfSections: Int!
                        
                        beforeEach {
                            numberOfSections = subject.numberOfSections(in: subject.tableView)
                        }
                        
                        it("returns the number of DateEvents in the dataSource") {
                            expect(numberOfSections).to.equal(subject.dataSource.count)
                        }
                    }
                    
                    describe("#tableView(_:numberOfRowsInSection)") {
                        var numberOfRows: Int!
                        
                        beforeEach {
                            numberOfRows = subject.tableView(subject.tableView, numberOfRowsInSection: 0)
                        }
                        
                        it("returns the total amount of events in the dataSource for a particular section") {
                            expect(numberOfRows).to.equal(subject.dataSource[0].events.count)
                        }
                    }
                    
                    describe("#tableView(_:titleForHeaderInSection") {
                        var titleForHeaderInSection: String!
                        
                        beforeEach {
                            titleForHeaderInSection = subject.tableView(subject.tableView,
                                                                        titleForHeaderInSection: 0)
                        }
                        
                        it("returns a string processed from a 'dateKey', from a DateEvent for a particular section") {
                            let expectedTitle = "-- \(subject.dataSource[0].dateKey) --"
                            
                            expect(titleForHeaderInSection).to.equal(expectedTitle)
                        }
                    }
                    
                    describe("#tableView(_:cellForRowAt:)") {
                        var cell: EventTableViewCell!

                        beforeEach {
                            cell = (subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! EventTableViewCell)
                        }
                        
                        it("returns a cell that is properly configured") {
                            let actualEvent = subject.dataSource[0].events[0]
                            
                            expect(cell.titleLabel.text).to.equal(actualEvent.title)
                            expect(cell.startDateLabel.text).to.equal(actualEvent.startTimeOnlyString)
                            expect(cell.endDateLabel.text).to.equal(actualEvent.endTimeOnlyString)
                        }
                    }
                }
            }
        }
    }
}
