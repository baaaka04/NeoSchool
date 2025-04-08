import SnapKit
import UIKit

class ConfirmCodeViewController: KeyboardMovableViewController, Notifiable, Confirmable, UITextFieldDelegate {
    private let email: String
    private let otcVC = OneTimeCodeViewController()

    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .regular, size: 18)
        let fullString = "На почту \(email) было выслано письмо с 4-значным кодом. Введите его ниже"
        let attributedString = NSMutableAttributedString(string: fullString)
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: AppFont.font(type: .medium, size: 18)]
        if let emailRange = fullString.range(of: email) {
            let nsRange = NSRange(emailRange, in: fullString)
            attributedString.addAttributes(boldAttributes, range: nsRange)
        }
        label.attributedText = attributedString
        label.textColor = .neobisDarkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let wrongCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Неверный код"
        label.font = AppFont.font(type: .medium, size: 16)
        label.textColor = .neobisSnackbarRed
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var sendCodeAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить код повторно", for: .normal)
        button.setTitleColor(.neobisDarkPurple, for: .normal)
        button.setTitleColor(.neobisLightGray, for: .disabled)
        button.backgroundColor = .clear
        button.titleLabel?.font = AppFont.font(type: .regular, size: 18)
        button.addTarget(self, action: #selector(didTapSendAgain), for: .touchUpInside)
        return button
    }()

    private lazy var proceedButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Далее", for: .normal)
        button.addTarget(self, action: #selector(didTapProceed), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(otcVC)
        view.addSubview(otcVC.view)
        otcVC.didMove(toParent: self)
        otcVC.delegate = self
        titleText = "Восстановление пароля"

        setupUI()
        didTapSendAgain()
    }

    private func setupUI() {
        view.addSubview(subtitleLabel)
        view.addSubview(wrongCodeLabel)
        view.addSubview(sendCodeAgainButton)
        view.addSubview(proceedButton)

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24) // titleLabel is in the parent
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-76)
        }
        otcVC.view.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-104)
        }
        wrongCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(otcVC.view.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        sendCodeAgainButton.snp.makeConstraints { make in
            make.top.equalTo(wrongCodeLabel.snp.bottom).offset(24)
            make.height.equalTo(22)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        proceedButton.snp.makeConstraints { make in
            make.top.equalTo(sendCodeAgainButton.snp.bottom).offset(24)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
    }

    private func updateToAlertUI() {
        otcVC.changeBorderColor(isAlert: true)
        wrongCodeLabel.isHidden = false
    }

    @objc private func didTapProceed() {
        Task {
            do {
                guard let code = Int(otcVC.getCode()),
                      let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
                if try await sceneDelegate.authService.checkResetPasswordCode(withCode: code) {
                    await MainActor.run {
                        let passwordCreateVC = PasswordCreationViewController(authService: sceneDelegate.authService)
                        passwordCreateVC.onChangeSuccess = { [weak self] in
                            self?.showConfirmView(confirmedAction: {
                                self?.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        passwordCreateVC.onChangeFailure = { [weak self] error in
                            print(error)
                            self?.showNotification(message: "Не удалось изменить пароль", isSucceed: false)
                        }
                        self.navigationController?.pushViewController(passwordCreateVC,animated: true)
                    }
                } else {
                    updateToAlertUI()
                }
            } catch { print(error) }
        }
    }

    @objc private func didTapSendAgain() {
        Task {
            do {
                guard let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
                try await sceneDelegate.authService.sendResetPasswordCode(for: self.email)
            } catch { print(error) }
        }
        var time = 45
        sendCodeAgainButton.setTitle("Отправить код повторно через 0:\(String(format: "%02d", time))", for: .disabled)
        sendCodeAgainButton.isEnabled = false
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            time -= 1
            self?.sendCodeAgainButton.setTitle("Отправить код повторно через 0:\(String(format: "%02d", time))", for: .disabled)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat(time)) { [weak self] in
            timer.invalidate()
            self?.sendCodeAgainButton.isEnabled = true
        }
    }
}

extension ConfirmCodeViewController: OneTimeCodeDelegate {
    func codeCleared() {
        proceedButton.isEnabled = false
        otcVC.changeBorderColor(isAlert: false)
        wrongCodeLabel.isHidden = true
    }

    func codeFilled() {
        proceedButton.isEnabled = true
    }
}
