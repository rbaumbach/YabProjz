@testable import Hyperloop

final class FakeAPIClient: APIClientProtocol {
    // MARK: - Captured properties
    
    var capturedEndpoint: String?
    var capturedParamters: [String: String]?
    var capturedHeaders: [String: String]?
    var capturedCompletionHandler: Any?
    
    func requestAndDeserialize<T: Codable>(endpoint: String,
                                           parameters: [String: String],
                                           headers: [String: String]?,
                                           completionHandler: @escaping (Result<T, Error>) -> Void) {
        capturedEndpoint = endpoint
        capturedParamters = parameters
        capturedHeaders = headers
        capturedCompletionHandler = completionHandler
    }
}
