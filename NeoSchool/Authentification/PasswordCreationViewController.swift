import SnapKit
import UIKit

class PasswordCreationViewController: KeyboardMovableViewController, UITextFieldDelegate {

    private let authService: AuthServiceProtocol

    var onChangeSuccess: (() -> Void)?
    var onChangeFailure: ((Error) -> Void)?

    private lazy var newPasswordInputView: AlertPasswordInputView = {
        let input = AlertPasswordInputView(
            placeholder: "Новый пароль",
            hintText: "Минимум 8 символов, включая цифры и спецсимволы (!, \", #, $ и т.д.)",
            isHintHidden: false
        )
        input.inputTextField.delegate = self
        input.addTarget = textFieldEditingChanged
        return input
    }()

    private lazy var confirmNewPasswordInputView: AlertPasswordInputView = {
        let input = AlertPasswordInputView(
            placeholder: "Новый пароль еще раз",
            hintText: "Пароли не совпадают",
            isHintHidden: true
        )
        input.inputTextField.delegate = self
        input.addTarget = textFieldEditingChanged
        return input
    }()

    private lazy var confirmButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Сохранить", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(onPressConfirm), for: .touchUpInside)
        return button
    }()

    init(authService: AuthServiceProtocol) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleText = "Создание пароля"
        setupUI()
    }

    private func setupUI() {
        view.addSubview(newPasswordInputView)
        view.addSubview(confirmNewPasswordInputView)
        view.addSubview(confirmButton)

        newPasswordInputView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(48) // titleLabel is in the parent
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        confirmNewPasswordInputView.snp.makeConstraints { make in
            make.top.equalTo(newPasswordInputView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(confirmNewPasswordInputView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(52)
        }
    }

    private func textFieldEditingChanged(_ sender: UITextField) {
        confirmNewPasswordInputView.setErrorVisible(false)
        updateUIValidation()
    }

    private func isNewPasswordValid() -> Bool {
        guard let text = newPasswordInputView.inputTextField.text, !text.isEmpty else { return true }
        return Validator.isPasswordValid(for: text)
    }

    private func updateUIValidation() {
        let isValid = isNewPasswordValid()
        newPasswordInputView.setErrorVisible(!isValid)
        let text1 = newPasswordInputView.inputTextField.text ?? ""
        let text2 = confirmNewPasswordInputView.inputTextField.text ?? ""

        confirmButton.isEnabled = isValid && !text1.isEmpty && !text2.isEmpty && text1.count == text2.count
    }

    private func arePasswordsEqual() -> Bool {
        guard
            let password = newPasswordInputView.inputTextField.text, !password.isEmpty,
            let confirmPassword = confirmNewPasswordInputView.inputTextField.text, !confirmPassword.isEmpty,
            password == confirmPassword
        else { return false }

        return true
    }

    @objc private func onPressConfirm() {
        if let password = newPasswordInputView.inputTextField.text, arePasswordsEqual() {
            Task {
                do {
                    try await authService.updatePassword(with: password)
                    self.onChangeSuccess?()
                } catch {
                    self.onChangeFailure?(error)
                }
            }
        } else {
            newPasswordInputView.showBorderAlertView()
            confirmNewPasswordInputView.setErrorVisible(true)
        }
    }
}
