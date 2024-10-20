import UIKit
import SnapKit

final class PerformanceViewController: SchoolNavViewController {

    private let userRole: UserRole
    private let performanceAPI: PerformanceAPIProtocol

    private lazy var rightTabTitle: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: "Четвертные оценки", attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFont.font(type: .Medium, size: 18)
        button.addTarget(self, action: #selector(onTapQuaterMarks), for: .touchUpInside)
        button.isHidden = self.userRole == .student
        return button
    }()

    init(navbarTitle: String, navbarColor: UIColor?, userRole: UserRole, performanceAPI: PerformanceAPIProtocol) {
        self.userRole = userRole
        self.performanceAPI = performanceAPI
        super.init(navbarTitle: navbarTitle, navbarColor: navbarColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        let gradesBar = GradesBarVC(performanceAPI: performanceAPI)
        addChild(gradesBar)
        view.addSubview(gradesBar.view)
        gradesBar.didMove(toParent: self)
        gradesBar.view.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width-32)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(168)
        }

        let marksPanel = MarksPanelVC(performanceAPI: performanceAPI)
        addChild(marksPanel)
        view.addSubview(marksPanel.view)
        marksPanel.didMove(toParent: self)
        marksPanel.view.snp.makeConstraints { make in
            make.top.equalTo(gradesBar.view.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.tabBarController?.tabBar.frame.size.height ?? 0)
        }
        gradesBar.delegate = marksPanel

        view.addSubview(rightTabTitle)
        rightTabTitle.snp.makeConstraints { make in
            make.centerY.equalTo(leftTabTitle)
            make.right.equalToSuperview().inset(16)
        }
    }

    @objc private func onTapQuaterMarks () {
        let vc = QuaterMarksDetailViewController(performanceAPI: performanceAPI)
        vc.title = "Четвертные оценки"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
