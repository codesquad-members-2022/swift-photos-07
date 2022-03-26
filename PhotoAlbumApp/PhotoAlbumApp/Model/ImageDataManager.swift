import Foundation
import Photos

class ImageDataManager {
    
    var binaryData: [Data] = []
    let imageManager = PHCachingImageManager()
    var fetchResults: PHFetchResult<PHAsset>?    // 앨범 정보
    let requestOptions = PHImageRequestOptions()
    private var fetchOptions = PHFetchOptions()
    
    init() {
        checkPermission()
    }
    
    func image2DataProcess() {
        requestImageCollection()
        fetchOptionsSetting()
        fetchImageToData()
    }
    
    func checkPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            self.requestImageCollection()
        case .denied: break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                switch $0 {
                case .authorized:
                    self.requestImageCollection()
                case .denied: break
                default:
                    break
                }
            })
        default:
            break
        }
    }
    
    func fetchOptionsSetting() {
        requestOptions.isSynchronous = true
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    }
    
    func requestImageCollection() {
        fetchResults = PHAsset.fetchAssets(with: fetchOptions)
    }
    
    func fetchImageToData() {
        
        guard let assets = fetchResults else { return }
        var resultData: [Data] = []
        assets.enumerateObjects { asset, _, _ in
            self.imageManager.requestImageDataAndOrientation(for: asset, options: self.requestOptions) { data, _, _, _ in
                guard let data = data else { return }
                resultData.append(data)
            }
        }
        self.binaryData = resultData
    }
}




