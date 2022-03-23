import UIKit

class ViewController: UIViewController {
    
    private let colors = ColorFactory.generateRandom(count: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
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
