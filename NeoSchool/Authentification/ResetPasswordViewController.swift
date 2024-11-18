import SnapKit
import UIKit

class ResetPasswordViewController: KeyboardMovableViewController, UITextFieldDelegate {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
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

    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        self.wrongEmailLabel.isHidden = true
        self.emailField.layer.borderColor = UIColor.neobisPurple.cgColor
        let prevEmail = emailField.text ?? ""
        var fullEmail = ""
        if string.isEmpty {
            fullEmail = String(prevEmail.dropLast())
        } else {
            fullEmail = prevEmail + string
        }
        if Validator.isValidEmail(for: fullEmail) {
            proceedButton.isEnabled = true
        } else {
            proceedButton.isEnabled = false
        }
        return true
    }

    @objc private func didTapProceed() {
        guard let email = emailField.text else { return }
        let authAPI = AuthService()
        Task { [weak self] in
            do {
                try await authAPI.sendResetPasswordCode(for: email)
                self?.navigationController?.pushViewController(
                    ConfirmCodeViewController(authAPI: authAPI, email: email),
                    animated: true
                )
            } catch {
                DispatchQueue.main.async {
                    self?.wrongEmailLabel.isHidden = false
                    self?.emailField.layer.borderWidth = 1
                    self?.emailField.layer.borderColor = UIColor.neobisRed.cgColor
                }
            }
        }
    }
}
