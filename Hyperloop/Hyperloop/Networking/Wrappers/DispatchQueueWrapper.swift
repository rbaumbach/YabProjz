import Foundation

protocol DispatchQueueWrapperProtocol {
    func mainAsync(execute: @escaping () -> Void)
}

final class DispatchQueueWrapper: DispatchQueueWrapperProtocol {
    func mainAsync(execute: @escaping () -> Void) {
        DispatchQueue.main.async(execute: execute)
    }
}
