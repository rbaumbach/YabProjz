import Quick
import Moocher
@testable import ConflictingEvents

final class EventTableViewCellSpec: QuickSpec {
    override class func spec() {
        describe("EventTableViewCell") {
            var subject: EventTableViewCell!
                                    
            beforeEach {
                let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
                
                subject = nib.instantiate(withOwner: nil).first as? EventTableViewCell
            }
            
            describe("#update(title:startDate:endDate:hasConflict:)") {
                describe("when hasConflict is true") {
                    beforeEach {
                        subject.update(title: "Lunch with Winnie",
                                       startDate: "12:00 PM",
                                       endDate: "1:00 PM",
                                       hasConflict: true)
                    }
                    
                    it("has updated all the labels appropriately") {
                        expect(subject.titleLabel.text).to.equal("Lunch with Winnie - CONFLICT!")
                        expect(subject.startDateLabel.text).to.equal("12:00 PM")
                        expect(subject.endDateLabel.text).to.equal("1:00 PM")
                    }
                }
                
                describe("when hasConflict is false") {
                    beforeEach {
                        subject.update(title: "Lunch with Pee-wee",
                                       startDate: "12:00 PM",
                                       endDate: "1:00 PM")
                    }
                    
                    it("has updated all the labels appropriately") {
                        expect(subject.titleLabel.text).to.equal("Lunch with Pee-wee")
                        expect(subject.startDateLabel.text).to.equal("12:00 PM")
                        expect(subject.endDateLabel.text).to.equal("1:00 PM")
                    }
                }
            }
        }
    }
}
