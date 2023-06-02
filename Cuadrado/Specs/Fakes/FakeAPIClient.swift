import Foundation
@testable import Cuadrado

enum FakeAPIClientError: Error {
    case whocares
}

class FakeAPIClient: APIClientProtocol {
    // MARK: - Captured properties
    
    var capturedGetEndpoint: String?
    var capturedGetCompletionHandler: ((Result<Any, APIClientError>) -> Void)?
        
    // MARK: - <APIClientProtocol>
    
    func get(endpoint: String, completionHandler: @escaping (Result<Any, APIClientError>) -> Void) {
        capturedGetEndpoint = endpoint
        capturedGetCompletionHandler = completionHandler
    }
}
