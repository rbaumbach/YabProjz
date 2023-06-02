import Quick
import Nimble
@testable import Cuadrado

class EmployeeNetworkServiceSpec: QuickSpec {
    override func spec() {
        describe("EmployeeNetworkService") {
            var subject: EmployeeNetworkService!
            
            var fakeAPIClient: FakeAPIClient!
            var fakeDeserializer: FakeEmployeeDeserializer!
            
            beforeEach {
                fakeAPIClient = FakeAPIClient()
                fakeDeserializer = FakeEmployeeDeserializer()

                subject = EmployeeNetworkService(apiClient: fakeAPIClient, deserializer: fakeDeserializer)
            }
            
            describe("#getEmployees(completionHandler:)") {
                var capturedResult: Result<[Employee], APIClientError>!
                
                it("constructs the client request to the proper endpoint") {
                    subject.getEmployees { _ in }
                    
                    expect(fakeAPIClient.capturedGetEndpoint).to(equal("/sq-mobile-interview/employees.json"))
                }
                
                describe("on api client success") {
                    beforeEach {
                        subject.getEmployees { result in
                            capturedResult = result
                        }
                        
                        let someJSON = [ "tacos": "burritos"]
                        
                        fakeAPIClient.capturedGetCompletionHandler?(.success(someJSON))
                    }
                    
                    it("deserializes the jsonResponse using deserializer") {
                        let capturedJSON = fakeDeserializer.capturedDeserializerJSONResponse as! [String: String]
                        
                        expect(capturedJSON).to(equal([ "tacos": "burritos"]))
                    }
                    
                    it("gives the completion handler an array of employees") {
                        do {
                            let employees = try capturedResult.get()
                            
                            expect(employees).to(equal(fakeDeserializer.stubbedEmployees))
                        } catch {
                            XCTFail("You should be able to get a successful array of employees")
                        }
                    }
                }
                
                describe("on api client failure") {
                    beforeEach {
                        subject.getEmployees { result in
                            capturedResult = result
                        }
                        
                        fakeAPIClient.capturedGetCompletionHandler?(.failure(APIClientError.sessionError))
                    }
                    
                    it("gives the completion handler the api client error") {
                        expect(capturedResult).to(equal(.failure(APIClientError.sessionError)))
                    }
                }
            }
        }
    }
}
