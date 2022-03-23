import UIKit
import Photos

class ViewController: UIViewController {
    
    //MARK: 사용하게 될 변수들
    private let colors = ColorFactory.generateRandom(count: 40)
    private var fetchResults: PHFetchResult<PHAsset>?    // 앨범 정보
    private let imageManager = PHCachingImageManager()    // 앨범에서 사진 받아오기 위한 객체
    private var fetchOptions: PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }    // 앨범 정보에 대한 옵션
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        checkPermission()
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

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell, let asset = fetchResults?[indexPath.row] else {
            return UICollectionViewCell()
        }
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
