import UIKit
import Photos

class ViewController: UIViewController {
    
    private let imageDataManager : ImageDataManager = ImageDataManager()
    @IBOutlet weak var collectionView: UICollectionView!
    private var thumbnailAssets = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerPhotoLibrary()
        imageDataManager.image2DataProcess()
        configureViewController()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
    

    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataManager.binaryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell  else {
            return UICollectionViewCell()
        }
        imageDataManager.imageManager.startCachingImages(for: thumbnailAssets, targetSize: cell.frame.size, contentMode: .default, options: imageDataManager.requestOptions)

        cell.imageView.image = UIImage(data: imageDataManager.binaryData[indexPath.row])
        cell.imageView.contentMode = .scaleToFill

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

extension ViewController : PHPhotoLibraryChangeObserver {
    
    func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let asset = imageDataManager.fetchResults, let changes = changeInstance.changeDetails(for: asset) else { return }
        
        imageDataManager.fetchResults = changes.fetchResultAfterChanges
        imageDataManager.fetchImageToData()
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }
}





