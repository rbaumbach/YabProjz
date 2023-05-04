import UIKit
import Capsule

class AsyncImageFetcher {
    // MARK: - Private properties
    
    private let imageViewImageCache: NSCache<NSString, UIImage>
    private let uuid: UUIDProtocol
    private let urlSession: URLSessionProtocol
    
    // MARK: - Readonly properties
    
    private(set) var inProgressImageDataTasks: [String: URLSessionDataTask] = [:]
    
    // MARK: - Init methods
    
    init(imageViewImageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>(),
         uuid: UUIDProtocol = UUID(),
         urlSession: URLSessionProtocol = URLSession.shared) {
        self.imageViewImageCache = imageViewImageCache
        self.uuid = uuid
        self.urlSession = urlSession
    }
    
    // MARK: - Public methods
    
    func fetch(imageURLString: String?, completionHandler: @escaping (UIImage?) -> Void) -> String? {
        guard let imageURLString = imageURLString else {
            completionHandler(nil)
            
            return nil
        }
        
        guard let imageURL = URL(string: imageURLString) else {
            completionHandler(nil)
            
            return nil
        }
        
        if let cachedImage = imageViewImageCache.object(forKey: imageURLString as NSString) {
            completionHandler(cachedImage)

            return nil
        }
        
        let imageFetchUUID = uuid.uuidString
        
        let dataTask = urlSession.dataTask(with: imageURL) { [weak self] data, _, error in
            guard let `self` = self else {
                completionHandler(nil)

                return
            }
            
            if (error as NSError?)?.code == NSURLErrorCancelled {
                self.inProgressImageDataTasks[imageFetchUUID] = nil
                
                completionHandler(nil)
                
                return
            }
            
            guard let data = data, error == nil else {
                self.inProgressImageDataTasks[imageFetchUUID] = nil
                
                completionHandler(nil)
                
                return
            }
            
            guard let image = UIImage(data: data) else {
                self.inProgressImageDataTasks[imageFetchUUID] = nil
                
                completionHandler(nil)
                
                return
            }
            
            self.imageViewImageCache.setObject(image, forKey: imageURLString as NSString)
                        
            self.inProgressImageDataTasks[imageFetchUUID] = nil
            
            completionHandler(image)
        }
        
        dataTask.resume()
        
        inProgressImageDataTasks[imageFetchUUID] = dataTask
                
        return imageFetchUUID
    }
    
    func cancel(imageFetchUUID: String) {
        inProgressImageDataTasks[imageFetchUUID]?.cancel()
        
        inProgressImageDataTasks[imageFetchUUID] = nil
    }
}
