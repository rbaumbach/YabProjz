import Foundation

protocol EmployeeDeserialzerProtocol {
    func deserialize(jsonResponse: Any) -> [Employee]
}

class EmployeeDeserialzer: EmployeeDeserialzerProtocol {
    // MARK: - Public methods
    
    func deserialize(jsonResponse: Any) -> [Employee] {
        guard let serializedJSONResponse = jsonResponse as? [String: Any] else {
            return []
        }
        
        guard let serializedEmployees = serializedJSONResponse["employees"] as? [[String: Any]] else {
            return []
        }
        
        let employees = serializedEmployees.map { serialedJSONEmployee -> Employee? in
            guard let serializedEmployee = serialedJSONEmployee as? [String: String] else {
                return nil
            }
                        
            let deserializedEmployee = deserializeEmployee(serializedEmployee: serializedEmployee)
            
            return deserializedEmployee
        }
        
        // Note: I'm only doing this based on the requirements of the document.  In "production" code, I'd do
        // a compact map to remove the nil employees (return employees without malformed data).
        // let finalEmployees = employees.compactMap { $0 }
        
        guard let finalEmployees = employees as? [Employee] else {
            return []
        }
        
        return finalEmployees
    }
    
    private func deserializeEmployee(serializedEmployee: [String: Any]) -> Employee? {
        // Required fields

        guard let id = serializedEmployee["uuid"] as? String,
              let fullName = serializedEmployee["full_name"] as? String,
              let emailAddress = serializedEmployee["email_address"] as? String,
              let team = serializedEmployee["team"] as? String,
              let typeString = serializedEmployee["employee_type"] as? String,
              let employeeType = EmployeeType(rawValue: typeString) else {
                return nil
        }
        
        // Optional fields
        
        let phoneNumber = serializedEmployee["phone_number"] as? String
        let biography = serializedEmployee["biography"] as? String
        
        var smallPhotoURL: URL?
        if let smallPhotoURLString = serializedEmployee["photo_url_small"] as? String {
            smallPhotoURL = URL(string: smallPhotoURLString)
        }
        
        var largePhotoURL: URL?
        if let largePhotoURLString = serializedEmployee["photo_url_large"] as? String {
            largePhotoURL = URL(string: largePhotoURLString)
        }
        
        let employee = Employee(id: id,
                                fullname: fullName,
                                phoneNumber: phoneNumber,
                                email: emailAddress,
                                biography: biography,
                                smallPhotoURL: smallPhotoURL,
                                largePhotoURL: largePhotoURL,
                                team: team,
                                type: employeeType)
        return employee
    }
}
