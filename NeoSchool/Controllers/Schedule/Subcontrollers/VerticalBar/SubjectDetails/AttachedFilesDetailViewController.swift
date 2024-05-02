import UIKit
import SnapKit

class AttachedFilesDetailViewController: DetailViewController {
    
    private let viewModel : SubjectDetailsViewModelRepresentable?
    private let attachedFilesVC : AttachedFilesViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    init(viewModel: SubjectDetailsViewModelRepresentable?) {
        self.viewModel = viewModel
        self.attachedFilesVC = AttachedFilesViewController(viewModel: viewModel)
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
