import Quick
import Nimble
@testable import Cuadrado

class EmployeeSpec: QuickSpec {
    override func spec() {
        describe("Employee") {
            var subject: Employee!

            beforeEach {
                let bio = "A martial arts superstar trained by Great Masters from around the world, Cage uses his talents on the big screen. He is the current box-office champ and star of such movies as Dragon Fist and Dragon Fist II as well as the Award-Winning Sudden Violence."
                
                subject = Employee(id: "12345",
                                   fullname: "Johnny Cage",
                                   phoneNumber: "555-555-5555",
                                   email: "johnny@cage.com",
                                   biography: bio,
                                   smallPhotoURL: URL(string: "https://photo1.com/small")!,
                                   largePhotoURL: URL(string: "https://photo1.com/large")!,
                                   team: "Heroes",
                                   type: .fullTime)
            }
            
            it("has an id") {
                expect(subject.id).to(equal("12345"))
            }
            
            it("has a full name") {
                expect(subject.fullname).to(equal("Johnny Cage"))
            }
            
            it("has a phone number") {
                expect(subject.phoneNumber).to(equal("555-555-5555"))
            }
            
            it("has an email") {
                expect(subject.email).to(equal("johnny@cage.com"))
            }
            
            it("has a biography") {
                let expectedBiography = "A martial arts superstar trained by Great Masters from around the world, Cage uses his talents on the big screen. He is the current box-office champ and star of such movies as Dragon Fist and Dragon Fist II as well as the Award-Winning Sudden Violence."
                
                expect(subject.biography).to(equal(expectedBiography))
            }
            
            it("has a small photo URL") {
                expect(subject.smallPhotoURL).to(equal(URL(string: "https://photo1.com/small")))
            }
            
            it("has a large photo URL") {
                expect(subject.largePhotoURL).to(equal(URL(string: "https://photo1.com/large")))
            }
            
            it("has a team") {
                expect(subject.team).to(equal("Heroes"))
            }
            
            it("has a type") {
                expect(subject.type).to(equal(.fullTime))
            }
        }
    }
}
