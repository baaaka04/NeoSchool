import SnapKit
import UIKit

class ResetPasswordViewController: KeyboardMovableViewController, UITextFieldDelegate {
    private let authService: AuthServiceProtocol

    var onChangeEmailSuccess: ((_ email: String) -> Void)?

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите электронную почту, которую вы указывали в профиле"
        label.font = AppFont.font(type: .regular, size: 18)
        label.textColor = .neobisDarkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let emailField = LoginTextField(fieldType: .email)

    private let wrongEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "Неверный адрес электронной почты"
        label.font = AppFont.font(type: .medium, size: 16)
        label.textColor = .neobisRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    lazy var proceedButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Далее", for: .normal)
        button.addTarget(self, action: #selector(didTapProceed), for: .touchUpInside)
        button.isEnabled = false
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
        emailField.delegate = self
        emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        titleText = "Восстановление пароля"

        setupUI()
    }

    private func setupUI() {
        view.addSubview(subtitleLabel)
        view.addSubview(emailField)
        view.addSubview(wrongEmailLabel)
        view.addSubview(proceedButton)

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24) // titleLabel is in the parent
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-76)
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(34)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        wrongEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(4)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        proceedButton.snp.makeConstraints { make in
            make.top.equalTo(wrongEmailLabel.snp.bottom).offset(24)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        wrongEmailLabel.isHidden = true
        textField.layer.borderColor = UIColor.neobisPurple.cgColor

        let text = textField.text ?? ""
        proceedButton.isEnabled = Validator.isValidEmail(for: text)
    }

    @objc private func didTapProceed() {
        guard let email = emailField.text else { return }
        Task {
            do {
                try await authService.sendResetPasswordCode(for: email)
                onChangeEmailSuccess?(email)
            } catch {
                await MainActor.run {
                    self.wrongEmailLabel.isHidden = false
                    self.emailField.layer.borderWidth = 1
                    self.emailField.layer.borderColor = UIColor.neobisRed.cgColor
                }
            }
        }
    }
}
