import UIKit
import SnapKit

class LastMarksDetailsVC: DetailTitledViewController {

    private let performanceAPI: PerformanceAPIProtocol
    private let quater: Quater
    private let subjectId: Int

    init(performanceAPI: PerformanceAPIProtocol, quater: Quater, subjectId: Int) {
        self.performanceAPI = performanceAPI
        self.quater = quater
        self.subjectId = subjectId
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

        let typeSwitchBar = HomeworkClassworkBarView()
        view.addSubview(typeSwitchBar)
        typeSwitchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.width.equalTo(titleLabel)
            make.height.equalTo(46)
        }
        let listsVC = StudentLastMarksListVC(performanceAPI: performanceAPI, quater: quater, subjectId: subjectId)
        addChild(listsVC)
        listsVC.didMove(toParent: self)
        view.addSubview(listsVC.view)
        listsVC.view.snp.makeConstraints { make in
            make.top.equalTo(typeSwitchBar.snp.bottom)
            make.width.bottom.equalToSuperview()
        }
        typeSwitchBar.delegate = listsVC
        listsVC.delegate = typeSwitchBar
    }
}

