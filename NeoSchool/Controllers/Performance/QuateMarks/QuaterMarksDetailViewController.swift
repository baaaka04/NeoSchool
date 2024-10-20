import UIKit
import SnapKit

class QuaterMarksDetailViewController: DetailViewController {

    private let performanceAPI: PerformanceAPIProtocol
    private let gradesBar: GradesBarVC
    private let quaterMarkListVC: QuaterMarkListViewController

    init(performanceAPI: PerformanceAPIProtocol) {
        self.performanceAPI = performanceAPI
        self.gradesBar = GradesBarVC(performanceAPI: performanceAPI, textColor: .neobisLightGray)
        self.quaterMarkListVC = QuaterMarkListViewController(performanceAPI: performanceAPI)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        addChild(gradesBar)
        view.addSubview(gradesBar.view)
        gradesBar.didMove(toParent: self)
        gradesBar.view.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width-32)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(118)
        }
        addChild(quaterMarkListVC)
        view.addSubview(quaterMarkListVC.view)
        quaterMarkListVC.didMove(toParent: self)
        quaterMarkListVC.view.snp.makeConstraints { make in
            make.top.equalTo(gradesBar.view.snp.bottom).offset(16)
            make.left.right.equalTo(gradesBar.view)
            make.bottom.equalToSuperview()
        }
        gradesBar.delegate = quaterMarkListVC
    }

}
