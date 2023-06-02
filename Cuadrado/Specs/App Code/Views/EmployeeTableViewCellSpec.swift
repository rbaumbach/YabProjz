import Quick
import Nimble
@testable import Cuadrado

class EmployeeTableViewCellSpec: QuickSpec {
    override func spec() {
        describe("EmployeeTableViewCell") {
            var subject: EmployeeTableViewCell!

            beforeEach {
                subject = loadCustomTableViewCell(name: EmployeeTableViewCell.reuseId)
            }
            
            // Note: All labels will be tested using their "placeholder" text
            
            it("has a fullname label") {
                expect(subject.fullnameLabel.text).to(equal("x fullname x"))
            }
            
            it("has a profile photo image view") {
                expect(subject.imageView).toNot(beNil())
            }
            
            it("has an email label") {
                expect(subject.emailLabel.text).to(equal("x email x"))
            }
            
            it("has a team label") {
                expect(subject.teamLabel.text).to(equal("x team x"))
            }
            
            it("has a type label") {
                expect(subject.typeLabel.text).to(equal("x type x"))
            }
            
            it("has a phone number label") {
                expect(subject.phoneNumberLabel.text).to(equal("x phone number x"))
            }
            
            it("has a biography label") {
                expect(subject.biographyLabel.text).to(equal("x biography x"))
            }
        }
    }
}
