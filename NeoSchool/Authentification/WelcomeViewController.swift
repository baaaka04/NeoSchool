import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    private let welcomeLabel: BigSemiBoldUILabel = {
        let label = BigSemiBoldUILabel()
        label.text = "Добро пожаловать!"
        return label
    }()
    
    private let globeImage = UIImageView(image: UIImage(named: "Globe") )
    
    lazy var studentButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Я ученик", for: .normal)
        button.addTarget(self, action: #selector(onTapStudentButton), for: .touchUpInside)
        return button
    }()
    
    lazy var teacherButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .white)
        button.setTitle("Я учитель", for: .normal)
        button.addTarget(self, action: #selector(onTapTeacherButton), for: .touchUpInside)
        return button
    }()

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
        let loginVC = LoginViewController(isTeacher: false)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc private func onTapTeacherButton() {
        let loginVC = LoginViewController(isTeacher: true)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }


}

