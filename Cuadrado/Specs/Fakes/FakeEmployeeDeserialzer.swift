import Foundation
@testable import Cuadrado

class FakeEmployeeDeserializer: EmployeeDeserialzerProtocol {
    // MARK: - Captured properties
    
    var capturedDeserializerJSONResponse: Any?
    
    // MARK: - Stubbed properties
    
    var stubbedEmployees: [Employee] = {
        let employee1 = Employee(id: "123",
                                 fullname: "Billy Goat",
                                 phoneNumber: "333-333-3333",
                                 email: "billy@goat.com",
                                 biography: "Just an ordinary billy goat",
                                 smallPhotoURL: nil,
                                 largePhotoURL: nil,
                                 team: "horns",
                                 type: .fullTime)
        
        let employee2 = Employee(id: "456",
                                 fullname: "Ram Goat",
                                 phoneNumber: "444-444-4444",
                                 email: "ram@goat.com",
                                 biography: "A goat with rams",
                                 smallPhotoURL: nil,
                                 largePhotoURL: nil,
                                 team: "horns",
                                 type: .contractor)
        
        return [employee1, employee2]
    }()
    
    // MARK: - <EmployeeNetworkServiceProtocol>
    
    func deserialize(jsonResponse: Any) -> [Employee] {
        capturedDeserializerJSONResponse = jsonResponse
        
        return stubbedEmployees
    }
}
