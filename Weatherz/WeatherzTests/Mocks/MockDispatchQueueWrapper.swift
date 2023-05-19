@testable import Weatherz

final class MockDispatchQueueWrapper: DispatchQueueWrapperProtocol {
    var capturedMainAsyncExecute: (() -> Void)?
    
    func mainAsync(execute: @escaping () -> Void) {
        capturedMainAsyncExecute = execute
    }
}
