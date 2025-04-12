import SnapKit
import UIKit

class WelcomeViewController: UIViewController {
    private let authService: AuthServiceProtocol

    var checkAuthentication: (() -> Void)?

    private let welcomeLabel: BigSemiBoldUILabel = {
        let label = BigSemiBoldUILabel()
        label.text = "Добро пожаловать!"
        return label
    }()

    private let globeImage = UIImageView(image: UIImage(named: Asset.globe) )

    private lazy var studentButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Я ученик", for: .normal)
        button.addTarget(self, action: #selector(onTapStudentButton), for: .touchUpInside)
        return button
    }()

    private lazy var teacherButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .white)
        button.setTitle("Я учитель", for: .normal)
        button.addTarget(self, action: #selector(onTapTeacherButton), for: .touchUpInside)
        return button
    }()

    init(authService: AuthServiceProtocol) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
    }

    private func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(globeImage)
        view.addSubview(studentButton)
        view.addSubview(teacherButton)

        teacherButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-72)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
            make.width.equalToSuperview().offset(-32)
        }
        studentButton.snp.makeConstraints { make in
            make.bottom.equalTo(teacherButton.snp.top).offset(-12)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
            make.width.equalToSuperview().offset(-32)
        }
        globeImage.snp.makeConstraints { make in
            make.bottom.equalTo(studentButton.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(222)
            make.height.equalTo(325)
        }
        welcomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(globeImage.snp.top).offset(-47)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    @objc private func onTapStudentButton() {
        UserDefaults.standard.set("student", forKey: "userRole")
        let loginVC = LoginViewController(authService: authService, isTeacher: false)
        loginVC.checkAuthentication = { [weak self] in self?.checkAuthentication?() }
        self.navigationController?.pushViewController(loginVC, animated: true)
    }

    @objc private func onTapTeacherButton() {
        UserDefaults.standard.set("teacher", forKey: "userRole")
        let loginVC = LoginViewController(authService: authService, isTeacher: true)
        loginVC.checkAuthentication = { [weak self] in self?.checkAuthentication?() }
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
