import UIKit

class ViewController: UIViewController {
    private let colors = ColorFactory.generateRandom(count: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

