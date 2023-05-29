import Foundation

@testable import Weatherz

final class MockURLSession: URLSessionProtocol {
    var capturedDataTaskRequest: URLRequest!
    var capturedDataTaskCompletionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    var stubbedDataTask = MockURLSessionDataTask()
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        capturedDataTaskRequest = request
        capturedDataTaskCompletionHandler = completionHandler
        
        return stubbedDataTask
    }
}
