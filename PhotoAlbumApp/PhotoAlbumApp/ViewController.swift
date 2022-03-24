import UIKit
import Photos

class ViewController: UIViewController {
    
    private let colors = ColorFactory.generateRandom(count: 40)
    private var fetchResults: PHFetchResult<PHAsset>?    // 앨범 정보
    private let imageManager = PHCachingImageManager()   // 앨범에서 사진 받아오기 위한 객체
    private var fetchOptions: PHFetchOptions {           // 앨범 정보에 대한 옵션
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        checkPermission()
        setRequestCollectionOption()
        
        PHPhotoLibrary.shared().register(self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
    
    //MARK: 접근 권한과 그에 따른 처리
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
    
    func requestImageCollection() {
        fetchResults = PHAsset.fetchAssets(with: nil)
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }
    
    private func setRequestCollectionOption() {
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        guard let cameraRollCollection = cameraRoll.firstObject else { return }
        
        self.fetchResults = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell,
                let asset = fetchResults?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        imageManager.startCachingImages(for: [asset], targetSize: cell.frame.size, contentMode: .default, options: nil)
        imageManager.requestImage(for: asset, targetSize: cell.frame.size, contentMode: .default, options: nil) { (image, _) in
            cell.imageView.image = image
            cell.imageView.contentMode = .scaleToFill
        }
        return cell
    }
}

extension ViewController {
    private func configureViewController() {
        title = "Photos"
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension ViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        //TODO: 변화 감지시 실행할 코드 작성
    }
}
