import Foundation
import UIKit

public actor ImageCache {
    public static let shared = ImageCache()
    
    private var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
        return cache
    }()
    
    public func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    public func insertImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    public func removeImage(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
}
