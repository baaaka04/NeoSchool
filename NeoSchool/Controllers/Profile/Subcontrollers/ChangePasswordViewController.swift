import SnapKit
import UIKit

class ChangePasswordViewController: DetailViewController, UITextFieldDelegate {
    private let authService: AuthServiceProtocol

    var onChangeSuccess: (() -> Void)?
    var onChangeFailure: ((_ err: Error) -> Void)?

    private let titleLabel: BigSemiBoldUILabel = {
        let label = BigSemiBoldUILabel()
        label.text = "Изменение пароля"
        if UIScreen.main.bounds.width <= 375 {
            label.font = AppFont.font(type: .semiBold, size: 24)
        }
        label.textAlignment = .left
        return label
    }()

    private lazy var currentPasswordInputView = makePasswordInputView(
        placeholder: "Текущий пароль",
        hintText: "Текущий пароль введен неверно",
        isHintHidden: true
    )

    private lazy var newPasswordInputView = makePasswordInputView(
        placeholder: "Новый пароль",
        hintText: "Минимум 8 символов, включая цифры и спецсимволы (!, \", #, $ и т.д.)",
        isHintHidden: false
    )

    private lazy var confirmNewPasswordInputView = makePasswordInputView(
        placeholder: "Новый пароль еще раз",
        hintText: "Пароли не совпадают",
        isHintHidden: true
    )

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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private func textFieldEditingChanged(_ sender: UITextField) {
        if sender === currentPasswordInputView.inputTextField {
            currentPasswordInputView.setErrorVisible(false)
        }

        confirmNewPasswordInputView.setErrorVisible(false)

        let newPassword = newPasswordInputView.inputTextField.text ?? ""
        let confirmPassword = confirmNewPasswordInputView.inputTextField.text ?? ""
        let currentPassword = currentPasswordInputView.inputTextField.text ?? ""

        // Update Tip/Error visibility for new password
        newPasswordInputView.setErrorVisible(!newPassword.isEmpty && !Validator.isPasswordValid(for: newPassword))

        // Update confirm button state
        let isValid = !currentPassword.isEmpty &&
        Validator.isPasswordValid(for: newPassword) &&
        !confirmPassword.isEmpty &&
        newPassword.count == confirmPassword.count

        confirmButton.isEnabled = isValid
    }

    private func makePasswordInputView(placeholder: String, hintText: String, isHintHidden: Bool) -> AlertPasswordInputView {
        let input = AlertPasswordInputView(
            placeholder: placeholder,
            hintText: hintText,
            isHintHidden: isHintHidden
        )
        input.inputTextField.delegate = self
        input.addTarget = textFieldEditingChanged
        return input
    }

    @objc private func onPressConfirm() {
        let currentPassword = currentPasswordInputView.inputTextField.text ?? ""
        let newPassword = newPasswordInputView.inputTextField.text ?? ""
        let confirmPassword = confirmNewPasswordInputView.inputTextField.text ?? ""

        guard !currentPassword.isEmpty,
              Validator.isPasswordValid(for: newPassword),
              newPassword == confirmPassword else {
            newPasswordInputView.showBorderAlertView()
            confirmNewPasswordInputView.setErrorVisible(true)
            return
        }

        Task {
            do {
                try await authService.changePassword(from: currentPassword, to: newPassword)
                onChangeSuccess?()
            } catch let error {
                switch error as? MyError {
                case .wrongPassword:
                    currentPasswordInputView.setErrorVisible(true)
                default:
                    onChangeFailure?(error)
                }
            }
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
