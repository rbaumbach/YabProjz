import Foundation
import SDWebImage
@testable import Cuadrado

class FakeSDWebImageWrapper: SDWebImageWrapperProtocol {
    // MARK: - Captured properties
    
    var didCallNeverExpireImageCache = false
    var capturedGetImageURL: URL?
    var capturedGetImageCompletionHandler: ((UIImage?) -> Void)?
    
    // MARK: - <SDWebImageWrapperProtocol>
    
    func neverExpireImageCache() {
        didCallNeverExpireImageCache = true
    }
    
    func getImage(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        capturedGetImageURL = url
        capturedGetImageCompletionHandler = completionHandler
    }
}
