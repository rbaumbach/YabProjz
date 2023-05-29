@testable import Weatherz

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var didCallResume = false
    
    func resume() {
        didCallResume = true
    }
}
