import Quick
import Nimble
@testable import Cuadrado

class EmployeeDeserialzerSpec: QuickSpec {
    override func spec() {
        describe("EmployeeDeserialzer") {
            var subject: EmployeeDeserialzer!

            beforeEach {
                subject = EmployeeDeserialzer()
            }
            
            describe("#deserialize(jsonResonse:)") {
                var employees: [Employee]!
                var jsonResponse: Any!
                
                describe("fully complete payload (all optional key/values exist)") {
                    beforeEach {
                        jsonResponse = [ "employees" : [ [ "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",
                                                           "full_name" : "Justine Mason",
                                                           "phone_number" : "5553280123",
                                                           "email_address" : "jmason.demo@squareup.com",
                                                           "biography" : "Engineer on the Point of Sale team.",
                                                           "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
                                                           "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",
                                                           "team" : "Point of Sale",
                                                           "employee_type" : "FULL_TIME" ],
                                                         
                                                         [  "uuid" : "a98f8a2e-c975-4ba3-8b35-01f719e7de2d",
                                                            "full_name" : "Camille Rogers",
                                                            "phone_number" : "5558531970",
                                                            "email_address" : "crogers.demo@squareup.com",
                                                            "biography" : "Designer on the web marketing team.",
                                                            "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/small.jpg",
                                                            "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/large.jpg",
                                                            "team" : "Public Web & Marketing",
                                                            "employee_type" : "PART_TIME" ] ] ]
                        
                        employees = subject.deserialize(jsonResponse: jsonResponse as Any)
                    }
                    
                    it("deserializes the jsonResponse properly") {
                        let expectedEmployee1 = Employee(id: "0d8fcc12-4d0c-425c-8355-390b312b909c",
                                                         fullname: "Justine Mason",
                                                         phoneNumber: "5553280123",
                                                         email: "jmason.demo@squareup.com",
                                                         biography: "Engineer on the Point of Sale team.",
                                                         smallPhotoURL: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg")!,
                                                         largePhotoURL: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg")!,
                                                         team: "Point of Sale",
                                                         type: .fullTime)
                        
                        let expectedEmployee2 = Employee(id: "a98f8a2e-c975-4ba3-8b35-01f719e7de2d",
                                                         fullname: "Camille Rogers",
                                                         phoneNumber: "5558531970",
                                                         email: "crogers.demo@squareup.com",
                                                         biography: "Designer on the web marketing team.",
                                                         smallPhotoURL: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/small.jpg")!,
                                                         largePhotoURL: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/large.jpg")!,
                                                         team: "Public Web & Marketing",
                                                         type: .partTime)
                        
                        expect(employees).to(equal([expectedEmployee1, expectedEmployee2]))
                    }
                }
                
                describe("payload with only required fields payload") {
                    beforeEach {
                        jsonResponse = [ "employees" : [ [ "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",
                                                           "full_name" : "Justine Mason",
                                                           "email_address" : "jmason.demo@squareup.com",
                                                           "team" : "Point of Sale",
                                                           "employee_type" : "FULL_TIME" ] ] ]
                        
                        employees = subject.deserialize(jsonResponse: jsonResponse as Any)
                    }
                    
                    it("deserializes the jsonResponse properly") {
                        let expectedEmployee = Employee(id: "0d8fcc12-4d0c-425c-8355-390b312b909c",
                                                        fullname: "Justine Mason",
                                                        email: "jmason.demo@squareup.com",
                                                        team: "Point of Sale",
                                                        type: .fullTime)
                        
                        expect(employees).to(equal([expectedEmployee]))
                    }
                }
                
                describe("malformed jsonResponses") {
                    describe("when it can't be parsed at the very top as a [String: Any] top level dictionary") {
                        beforeEach {
                            jsonResponse = [5]
                            
                            employees = subject.deserialize(jsonResponse: jsonResponse as Any)
                        }
                        
                        it("returns no employees") {
                            expect(employees).to(beEmpty())
                        }
                    }
                    
                    describe("when it doesn't have an 'employees' key, that contains an array of [String: Any] serialized employee objects") {
                        beforeEach {
                            jsonResponse = ["junk": [5]]
                            
                            employees = subject.deserialize(jsonResponse: jsonResponse as Any)
                        }
                        
                        it("returns no employees") {
                            expect(employees).to(beEmpty())
                        }
                    }
                    
                    describe("when an employee obj is missing or has a malformed required uuid field") {
                        beforeEach {
                            jsonResponse = [ "employees" : [ [ "uuid" : 55,
                                                               "full_name" : "Justine Mason",
                                                               "email_address" : "jmason.demo@squareup.com",
                                                               "team" : "Point of Sale",
                                                               "employee_type" : "FULL_TIME" ] ] ]
                            
                            employees = subject.deserialize(jsonResponse: jsonResponse as Any)
                        }
                        
                        it("returns no employees") {
                            expect(employees).to(beEmpty())
                        }
                    }
                    
                    describe("when an employee obj is missing or has a malformed required fullname field") {
                        beforeEach {
                            jsonResponse = [ "employees" : [ [ "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",
                                                               "email_address" : "jmason.demo@squareup.com",
                                                               "team" : "Point of Sale",
                                                               "employee_type" : "FULL_TIME" ] ] ]
                            
                            employees = subject.deserialize(jsonResponse: jsonResponse as Any)
                        }
                        
                        it("returns no employees") {
                            expect(employees).to(beEmpty())
                        }
                    }
                    
                    describe("when an employee obj is missing or has a malformed required email address field") {
                        beforeEach {
                            jsonResponse = [ "employees" : [ [ "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",
                                                               "full_name" : "Justine Mason",
                                                               "email_address" : 55.0000,
                                                               "team" : "Point of Sale",
                                                               "employee_type" : "FULL_TIME" ] ] ]
                            
                            employees = subject.deserialize(jsonResponse: jsonResponse as Any)
                        }
                        
                        it("returns no employees") {
                            expect(employees).to(beEmpty())
                        }
                    }
                    
                    describe("when an employee obj is missing or has a malformed required team field") {
                        beforeEach {
                            jsonResponse = [ "employees" : [ [ "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",
                                                               "full_name" : "Justine Mason",
                                                               "email_address" : "jmason.demo@squareup.com",
                                                               "employee_type" : "FULL_TIME" ] ] ]
                            
                            employees = subject.deserialize(jsonResponse: jsonResponse as Any)
                        }
                        
                        it("returns no employees") {
                            expect(employees).to(beEmpty())
                        }
                    }
                    
                    describe("when an employee obj is missing or has a malformed required type field") {
                        beforeEach {
                            jsonResponse = [ "employees" : [ [ "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",
                                                               "full_name" : "Justine Mason",
                                                               "email_address" : "jmason.demo@squareup.com",
                                                               "team" : "Point of Sale",
                                                               "employee_type" : "JUNK_TYPE" ] ] ]
                            
                            employees = subject.deserialize(jsonResponse: jsonResponse as Any)
                        }
                        
                        it("returns no employees") {
                            expect(employees).to(beEmpty())
                        }
                    }
                }
            }
        }
    }
}


/*
 
 Guide for key/values
 
 Key : Type : Required? : Notes
 
 uuid : string : YES : The unique identifier for the employee. Represented as a UUID.
 full_name : string: YES : The full name of the employee.
 phone_number : string : NO : The phone number of the employee, sent as an unformatted string (eg, 5556661234).
 email_address : string : YES : The email address of the employee.
 biography : string : NO : A short, tweet-length (~300 chars) string that the employee provided to describe themselves.
 photo_url_small : string : NO : The URL of the employee’s small photo. Useful for list view.
 photo_url_large : string : NO : The URL of the employee’s full-size photo.
 team : string : YES : The team they are on, represented as a human readable string.
 employee_type : enum (FULL_TIME, PART_TIME, CONTRACTOR) : YES : How the employee is classified.
 
 */
