import UIKit
import Photos

class ViewController: UIViewController {
    
    private let colors = ColorFactory.generateRandom(count: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requiredAccessLevel: PHAccessLevel = .readWrite
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in
            switch authorizationStatus {
            case .limited:
                print("limited authorization granted")
            case .authorized:
                print("authorization granted")
            default:
                //FIXME: Implement handling for all authorizationStatus
                print("Unimplemented")
            }
        }
        
        configureViewController()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
    
    private func setPhotoLibraryImage() {
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 1
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
        if let photo = fetchPhotos.firstObject {
            DispatchQueue.main.async {
                ImageManager.shared.requestImage(from: photo, thumnailSize: CGSize(width: 80.0, height: 80.0)) { image in
                // 가져온 이미지로 (image 파라미터) 하고싶은 행동
                }
           }
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = colors[indexPath.item]
        return cell
    }
    
}

extension ViewController {
    
    @objc func rightBarButtonItemTouched() {

    }

}

extension ViewController {
    private func configureViewController() {
        title = "Photos"
    }
}
