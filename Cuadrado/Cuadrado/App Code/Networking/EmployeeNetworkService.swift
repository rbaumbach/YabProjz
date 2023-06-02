import Foundation

protocol EmployeeNetworkServiceProtocol {
    func getEmployees(completionHandler: @escaping (Result<[Employee], APIClientError>) -> Void)
}
 
class EmployeeNetworkService: EmployeeNetworkServiceProtocol {
    // MARK: - Private Constants
    
    private let endpoint = "/sq-mobile-interview/employees.json"
//    private let endpoint = "/sq-mobile-interview/employees_empty.json"
//    private let endpoint = "/sq-mobile-interview/employees_malformed.json"

    // MARK: - Private properties
    
    private let apiClient: APIClientProtocol
    private let deserializer: EmployeeDeserialzerProtocol
    
    // MARK: - Init method
    
    init(apiClient: APIClientProtocol = APIClient(),
         deserializer: EmployeeDeserialzerProtocol = EmployeeDeserialzer()) {
        self.apiClient = apiClient
        self.deserializer = deserializer
    }
    
    // MARK: - Public methods
    
    func getEmployees(completionHandler: @escaping (Result<[Employee], APIClientError>) -> Void) {
        apiClient.get(endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let jsonResponse):
                guard let self = self else {
                    return
                }
                
                let employees = self.deserializer.deserialize(jsonResponse: jsonResponse)
                
                completionHandler(.success(employees))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
