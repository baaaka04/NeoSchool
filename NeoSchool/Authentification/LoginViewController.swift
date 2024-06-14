import UIKit
import SnapKit

class LoginViewController: DetailViewController, Notifiable, UITextFieldDelegate {

    private let isTeacher: Bool
    
    private let enteringLabel = BigSemiBoldUILabel()
    
    private let usernameField = CustomTextField(fieldType: .username)
    private let passwordField = CustomTextField(fieldType: .password)
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .neobisLightPurple
        button.titleLabel?.font = AppFont.font(type: .Regular, size: 20)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
    }()
    
    lazy var forgetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.neobisDarkPurple, for: .normal)
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = AppFont.font(type: .Regular, size: 18)
        button.addTarget(self, action: #selector(didTapForgetPassword), for: .touchUpInside)
        return button
    }()
    
    init(isTeacher: Bool) {
        self.isTeacher = isTeacher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        enteringLabel.text = "Вход"
        
        view.addSubview(enteringLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(forgetButton)
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-350)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        forgetButton.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.top).offset(-20)
            make.height.equalTo(18)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        passwordField.snp.makeConstraints { make in
            make.bottom.equalTo(forgetButton.snp.top).offset(-20)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        usernameField.snp.makeConstraints { make in
            make.bottom.equalTo(passwordField.snp.top).offset(-12)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        enteringLabel.snp.makeConstraints { make in
            make.bottom.equalTo(usernameField.snp.top).offset(-37)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        
    }
    
    private func updateButtonUI() {
        if let text1 = usernameField.text, !text1.isEmpty,
           let text2 = passwordField.text, !text2.isEmpty {
            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = .neobisPurple
        } else {
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = .neobisLightPurple
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Hide both of the TextFields red border every time the user change it
        usernameField.layer.borderWidth = 0
        passwordField.layer.borderWidth = 0
        
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let originalText = textField.text
        
        //Change the TextField BEFORE the function returns
        textField.text = updatedText
        //Update the button's properties
        updateButtonUI()
        //Return to the TextField its original state, because it WILL change after the executing of this function anyway
        textField.text = originalText
        
        return true
    }
    
    @objc private func didTapLogin() {
        let authService = AuthService()
        
        Task {
            guard let username = usernameField.text, let password = passwordField.text else { return }
            try await authService.login(username: username, password: password, isTeacher: self.isTeacher) { [weak self] done in
                if done {
                    if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.checkAuthentication()
                    }
                } else {
                    self?.showNotification(message: "Неверный логин или пароль", isSucceed: false)
                    self?.usernameField.layer.borderWidth = 1
                    self?.usernameField.layer.borderColor = UIColor.neobisRed.cgColor
                    self?.passwordField.layer.borderWidth = 1
                    self?.passwordField.layer.borderColor = UIColor.neobisRed.cgColor
                }
            }
        }
    }
    
    @objc private func didTapForgetPassword() {
        let resetPasswordVC = ResetPasswordViewController()
        self.navigationController?.pushViewController(resetPasswordVC, animated: true)
    }

}
