import UIKit
import SnapKit

class AttachedFilesDetailViewController: DetailViewController {
    
    private let attachedFilesVC : FilesCollectionViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    init(URLs: [String]?) {
        self.attachedFilesVC = FilesCollectionViewController(urls: URLs)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addChild(attachedFilesVC)
        view.addSubview(attachedFilesVC.view)
        attachedFilesVC.didMove(toParent: self)
                
        attachedFilesVC.view.snp.makeConstraints { make in
            make.top.height.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
    }
    
}
