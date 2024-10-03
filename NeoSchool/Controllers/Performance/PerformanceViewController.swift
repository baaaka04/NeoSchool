import UIKit
import SnapKit

final class PerformanceViewController: SchoolNavViewController {

    private let userRole: UserRole
    private let performanceVM = PerformanceViewModel()

    init(navbarTitle: String, navbarColor: UIColor?, userRole: UserRole) {
        self.userRole = userRole
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
        let gradesBar = GradesBarVC(vm: performanceVM)
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

    }

}
