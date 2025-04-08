import SnapKit
import UIKit

class ChangePasswordViewController: DetailViewController, Confirmable, UITextFieldDelegate {

    private let titleLabel: BigSemiBoldUILabel = {
        let label = BigSemiBoldUILabel()
        label.text = "Изменение пароля"
        if UIScreen.main.bounds.width <= 375 {
            label.font = AppFont.font(type: .semiBold, size: 24)
        }
        label.textAlignment = .left
        return label
    }()

    private lazy var currentPasswordInputView: AlertPasswordInputView = {
        let input = AlertPasswordInputView(placeholder: "Текущий пароль",
                                           hintText: "Текущий пароль введен неверно",
                                           isHintHidden: true)
        input.inputTextField.delegate = self
        return input
    }()

    private lazy var newPasswordInputView: AlertPasswordInputView = {
        let input = AlertPasswordInputView(placeholder: "Новый пароль",
                                           hintText: "Минимум 8 символов, включая цифры и спецсимволы (!, \", #, $ и т.д.)",
                                           isHintHidden: false)
        input.inputTextField.delegate = self
        return input
    }()

    private lazy var confirmNewPasswordInputView: AlertPasswordInputView = {
        let input = AlertPasswordInputView(placeholder: "Новый пароль еще раз",
                                           hintText: "Пароли не совпадают",
                                           isHintHidden: true)
        input.inputTextField.delegate = self
        return input
    }()

    private lazy var confirmButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Сохранить", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(onPressConfirm), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(currentPasswordInputView)
        view.addSubview(newPasswordInputView)
        view.addSubview(confirmNewPasswordInputView)
        view.addSubview(confirmButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(112)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        currentPasswordInputView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        newPasswordInputView.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordInputView.snp.bottom).offset(16)
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Hide alert if current password textFiled is changing
        if let text = textField.text, text == currentPasswordInputView.inputTextField.text {
            currentPasswordInputView.setErrorVisible(false)
        }
        // Hide the TextField's red border every time the user change it
        confirmNewPasswordInputView.setErrorVisible(false)

        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let originalText = textField.text

        // Change the TextField BEFORE the function returns
        textField.text = updatedText
        // Update the button's properties
        updateTipLabelUI()
        updateButtonUI()
        // Return to the TextField its original state, because it WILL change after the executing of this function anyway
        textField.text = originalText

        return true
    }

    private func isNewPasswordValid() -> Bool {
        guard let text = newPasswordInputView.inputTextField.text, !text.isEmpty else { return true }
        return Validator.isPasswordValid(for: text)
    }

    private func updateTipLabelUI() {
        isNewPasswordValid() ? newPasswordInputView.setErrorVisible(false) : newPasswordInputView.setErrorVisible(true)
    }

    private func areAllInputsValid() -> Bool {
        guard
            let text0 = currentPasswordInputView.inputTextField.text, !text0.isEmpty,
            let text1 = newPasswordInputView.inputTextField.text, !text1.isEmpty,
            let text2 = confirmNewPasswordInputView.inputTextField.text, !text2.isEmpty
        else { return false }

        return text1.count == text2.count
    }

    private func updateButtonUI() {
        self.confirmButton.isEnabled = isNewPasswordValid() ? areAllInputsValid() : false
    }

    private func arePasswordsValid() -> Bool {
        guard
            let currentPassword = currentPasswordInputView.inputTextField.text, !currentPassword.isEmpty,
            let newPassword = newPasswordInputView.inputTextField.text, !newPassword.isEmpty,
            let confirmPassword = confirmNewPasswordInputView.inputTextField.text, !confirmPassword.isEmpty,
            newPassword == confirmPassword
        else {
            return false
        }

        return true
    }

    @objc private func onPressConfirm() {
        if arePasswordsValid() {
            Task {
                do {
                    guard let currentPassword = currentPasswordInputView.inputTextField.text,
                          let password = newPasswordInputView.inputTextField.text,
                          let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else {
                        print("sceneDelegate failed")
                        return
                    }

                    try await sceneDelegate.authService.changePassword(from: currentPassword, to: password) { done in
                        if done { // If the user sends correct current password
                            self.showConfirmView(confirmedAction: { [weak self] in
                                sceneDelegate.checkAuthentication()
                                self?.navigationController?.popToRootViewController(animated: true)
                            })
                            // If the user sends incorrect current password
                        } else { self.currentPasswordInputView.setErrorVisible(true) }
                    }
                } catch { print(error) }
            }
        } else {
            newPasswordInputView.showBorderAlertView()
            confirmNewPasswordInputView.setErrorVisible(true)
        }
    }
}

// MARK: - Keyboard handlers
extension ChangePasswordViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillShow(_:)),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillHide(_:)),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }

    @objc func keyboardWillShow(_: Notification) {
        if UIScreen.main.bounds.width <= 375 {
            titleLabel.snp.updateConstraints { $0.top.equalTo(self.view.snp.top).offset(25) }
            titleLabel.textAlignment = .center
        }
    }

    @objc func keyboardWillHide(_: Notification) {
        titleLabel.snp.updateConstraints { $0.top.equalTo(self.view.snp.top).offset(112) }
        titleLabel.textAlignment = .left
    }
}
