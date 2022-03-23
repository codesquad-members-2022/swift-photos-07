import UIKit

class PhotoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
}

extension PhotoViewController {
    private func configureViewController() {
        title = "Photos"
        view.backgroundColor = .systemBackground
    }
}
