import UIKit

class AsyncImageFetcher {
    // MARK: - Private properties
    
    private let imageViewImageCache = NSCache<NSString, UIImage>()
    
    private var inProgressImageDataTasks: [String: URLSessionDataTask] = [:]
    
    // MARK: - Public methods
    
    func fetchImage(imageURLString: String?, completionHandler: @escaping (UIImage?) -> Void) -> String? {
        guard let imageURLString = imageURLString else {
            return nil
        }
        
        guard let imageURL = URL(string: imageURLString) else {
            return nil
        }
        
        if let cachedImage = imageViewImageCache.object(forKey: imageURLString as NSString) {
            completionHandler(cachedImage)
            
            return nil
        }

        let uuid = UUID().uuidString
        
        let dataTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            defer {
                self?.inProgressImageDataTasks[uuid] = nil
            }

            guard let `self` = self else {
                completionHandler(nil)

                return
            }

            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                completionHandler(nil)

                return
            }
            
            guard let data = data, error == nil else {
                completionHandler(nil)

                return
            }

            guard let image = UIImage(data: data) else {
                completionHandler(nil)

                return
            }

            self.imageViewImageCache.setObject(image, forKey: imageURLString as NSString)

            completionHandler(image)
        }

        dataTask.resume()

        inProgressImageDataTasks[uuid] = dataTask
        
        return uuid
    }
    
    func cancelImageFetch(_ uuid: String) {
        if let inProgressDataTask = inProgressImageDataTasks[uuid] {
            inProgressDataTask.cancel()
        }
        
        inProgressImageDataTasks[uuid] = nil
    }
}
