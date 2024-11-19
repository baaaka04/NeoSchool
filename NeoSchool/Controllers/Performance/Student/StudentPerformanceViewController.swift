import SnapKit
import UIKit

final class StudentPerformanceViewController: SchoolNavViewController {
    private let performanceAPI: PerformanceAPIProtocol

    init(navbarTitle: String, navbarColor: UIColor?, performanceAPI: PerformanceAPIProtocol) {
        self.performanceAPI = performanceAPI
        super.init(navbarTitle: navbarTitle, navbarColor: navbarColor)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        let quatersBar = QuatersBarVC()
        addChild(quatersBar)
        view.addSubview(quatersBar.view)
        quatersBar.didMove(toParent: self)
        quatersBar.view.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width - 32)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(168)
        }

        let marksPanel = QuaterMarksPanelVC(performanceAPI: performanceAPI)
        addChild(marksPanel)
        view.addSubview(marksPanel.view)
        marksPanel.didMove(toParent: self)
        marksPanel.view.snp.makeConstraints { make in
            make.top.equalTo(quatersBar.view.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.tabBarController?.tabBar.frame.size.height ?? 0)
        }
        quatersBar.delegate = marksPanel
    }
}
