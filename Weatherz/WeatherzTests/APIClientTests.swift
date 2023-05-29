import XCTest
@testable import Weatherz

final class APIClientTests: XCTestCase {
    var subject: APIClient!
    
    var mockURLSession: MockURLSession!
    var mockDispatchQueueWrapper: MockDispatchQueueWrapper!
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = MockURLSession()
        mockDispatchQueueWrapper = MockDispatchQueueWrapper()
        
        subject = APIClient(baseURL: "https://nevaz-existed99.codes",
                            urlSession: mockURLSession,
                            dispatchQueueWrapper: mockDispatchQueueWrapper)
    }
    
    // Only writing one test to demonstrate how to test a "dispatch" method
    
    func testCompletionHandlerIsDispatchedOnMain() {
        subject.requestAndDeserialize(endpoint: "/endpoint",
                                      parameters: [:]) { (result: Result<Int, Error>) in }
                
        mockURLSession.capturedDataTaskCompletionHandler?(nil, nil, MockError.whoCares)

        
        XCTAssertNotNil(mockDispatchQueueWrapper.capturedMainAsyncExecute)
    }
}
