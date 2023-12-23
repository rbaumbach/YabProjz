import Quick
import Moocher
@testable import ConflictingEvents

final class DateFormatterBuilderIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("DateFormatterBuilder") {
            it("has an eventJSONFormat") {
                expect(DateFormatterBuilder.eventJSONFormat.dateFormat).to.equal("MMMM d, yyyy hh:mm a")
            }
            
            it("has an eventTimeOnlyFormat") {
                expect(DateFormatterBuilder.eventTimeOnlyFormat.dateFormat).to.equal("hh:mm a")
            }
            
            it("has an eventDateOnlyFormat") {
                expect(DateFormatterBuilder.eventDateOnlyFormat.dateFormat).to.equal("MM/dd/yyyy")
            }
        }
    }
}
