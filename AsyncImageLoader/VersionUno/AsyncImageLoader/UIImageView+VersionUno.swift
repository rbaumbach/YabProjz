import UIKit

fileprivate let imageViewImageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    private struct AssociatedKeys {
        static var imageURLString: String?
    }

    var imageURLString: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.imageURLString) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.imageURLString, newValue as String?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIImageView {
    // MARK: - Public methods
    
    func setImage(imageURLString: String?) {
        self.imageURLString = imageURLString
        
        image = nil

        guard let imageURLString = imageURLString else {
            return
        }
        
        guard let imageURL = URL(string: imageURLString) else {
            return
        }
                        
        if let cachedImage = imageViewImageCache.object(forKey: imageURLString as NSString) {
            image = cachedImage
            
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            guard let `self` = self else {
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    return
                }
                
                imageViewImageCache.setObject(image, forKey: imageURLString as NSString)
                
                if self.imageURLString == imageURLString {
                    self.image = image
                }
            }
        }
        
        dataTask.resume()
    }
}
