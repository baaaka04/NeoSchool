import SnapKit
import UIKit

class LoginViewController: KeyboardMovableViewController, Notifiable, UITextFieldDelegate {
    private let authService: AuthServiceProtocol
    private let isTeacher: Bool

    var checkAuthentication: (() -> Void)?

    private let usernameField = LoginTextField(fieldType: .username)
    private let passwordField = LoginTextField(fieldType: .password)

    lazy var loginButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    lazy var forgetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.neobisDarkPurple, for: .normal)
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = AppFont.font(type: .regular, size: 18)
        button.addTarget(self, action: #selector(didTapForgetPassword), for: .touchUpInside)
        return button
    }()

    init(authService: AuthServiceProtocol, isTeacher: Bool) {
        self.authService = authService
        self.isTeacher = isTeacher
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        usernameField.delegate = self
        usernameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordField.delegate = self
        passwordField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func setupUI() {
        view.backgroundColor = .white
        titleText = "Вход"

        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(forgetButton)
        view.addSubview(loginButton)

        usernameField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(37) // titleLabel is in the parent
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(12)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        forgetButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.height.equalTo(18)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(forgetButton.snp.bottom).offset(20)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
    }

    private func updateButtonUI() {
        if let text1 = usernameField.text, !text1.isEmpty,
           let text2 = passwordField.text, !text2.isEmpty {
            self.loginButton.isEnabled = true
        } else {
            self.loginButton.isEnabled = false
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateButtonUI()
    }

    @objc private func didTapLogin() {
        guard let username = usernameField.text, let password = passwordField.text else { return }
        Task {
            do {
                try await authService.login(username: username, password: password, isTeacher: self.isTeacher) { [weak self] done in
                    if done {
                        self?.checkAuthentication?()
                    } else {
                        self?.showNotification(message: "Неверный логин или пароль", isSucceed: false)
                        self?.usernameField.layer.borderWidth = 1
                        self?.usernameField.layer.borderColor = UIColor.neobisRed.cgColor
                        self?.passwordField.layer.borderWidth = 1
                        self?.passwordField.layer.borderColor = UIColor.neobisRed.cgColor
                    }
                }
            } catch { print(error) }
        }
    }

    @objc private func didTapForgetPassword() {
        let resetPasswordVC = ResetPasswordViewController(authService: authService)
        resetPasswordVC.onChangeEmailSuccess = { [weak self, authService] email in
            self?.navigationController?.pushViewController(
                ConfirmCodeViewController(authService: authService, email: email),
                animated: true
            )
        }
        self.navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
}
