import Photos
import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    private let imageManager = PHImageManager()
    
    func requestImage(from asset: PHAsset, thumnailSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        self.imageManager.requestImage(for: asset, targetSize: thumnailSize, contentMode: .aspectFill, options: nil) { image, info in
            completion(image)
        }
    }
}
