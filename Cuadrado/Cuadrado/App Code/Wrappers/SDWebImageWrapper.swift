import UIKit
import SDWebImage

// MARK: - SDWebImageWrapper

protocol SDWebImageWrapperProtocol {
    func neverExpireImageCache()
    func getImage(url: URL, completionHandler: @escaping (UIImage?) -> Void)
}

class SDWebImageWrapper: SDWebImageWrapperProtocol {
    // MARK: - Public methods
    
    func neverExpireImageCache() {
        // Dox for SDWebImage state to set the maxDiskAge to a negative number to never expire the cache
        
        SDImageCache.shared.config.maxDiskAge = -1
    }
    
    func getImage(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { image, _, error, _, _, _ in
            guard error == nil else {
                completionHandler(nil)
                
                return
            }
            
            completionHandler(image)
        }
    }
}
