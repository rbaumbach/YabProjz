import Foundation
@testable import Cuadrado

class FakeEmployeeNetworkService: EmployeeNetworkServiceProtocol {
    // MARK: - Captured properties
    
    var capturedCompletionHandler: ((Result<[Employee], APIClientError>) -> Void)?
        
    // MARK: - <EmployeeNetworkServiceProtocol>
    
    func getEmployees(completionHandler: @escaping (Result<[Employee], APIClientError>) -> Void) {
        capturedCompletionHandler = completionHandler
    }
}
