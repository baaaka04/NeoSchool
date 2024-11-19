import SnapKit
import UIKit

class SchoolNavViewController: UIViewController {
    let navbarTitle: String
    let navbarColor: UIColor?

    private lazy var ellipseView = EllipseView(color: navbarColor)

    lazy var leftTabTitle: UILabel = {
        let label = UILabel()
        label.text = navbarTitle
        label.font = AppFont.font(type: .semiBold, size: 32)
        label.textColor = .white
        return label
    }()

    init(navbarTitle: String, navbarColor: UIColor?) {
        self.navbarTitle = navbarTitle
        self.navbarColor = navbarColor
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureNavBar()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func configureNavBar () {
        ellipseView.backgroundColor = .clear

        view.addSubview(ellipseView)
        view.addSubview(leftTabTitle)

        ellipseView.snp.makeConstraints { make in
            make.width.equalTo(644)
            make.height.equalTo(390)
            make.centerY.equalTo(72)
            make.centerX.equalToSuperview()
        }
        leftTabTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(112)
            make.left.equalToSuperview().inset(16)
        }
    }
}
