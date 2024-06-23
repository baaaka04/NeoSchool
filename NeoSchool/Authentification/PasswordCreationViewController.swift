import UIKit
import SnapKit

class PasswordCreationViewController: KeyboardMovableViewController, Confirmable, UITextFieldDelegate {
    
    private let authAPI: AuthService
    
    private lazy var newPasswordInputView: AlertPasswordInputView = {
        let input = AlertPasswordInputView(placeholder: "Новый пароль", hintText: "Минимум 8 символов, включая цифры и спецсимволы (!, \", #, $ и т.д.)", isHintHidden: false)
        input.inputTextField.delegate = self
        return input
    }()
    
    private lazy var confirmNewPasswordInputView: AlertPasswordInputView = {
        let input = AlertPasswordInputView(placeholder: "Новый пароль еще раз", hintText: "Пароли не совпадают", isHintHidden: true)
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
    
    init(authAPI: AuthService) {
        self.authAPI = authAPI
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
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
            make.top.equalTo(titleLabel.snp.bottom).offset(48) //titleLabel is in the parent
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
        //Hide the TextField's red border every time the user change it
        confirmNewPasswordInputView.hideAlertView()
        
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let originalText = textField.text
        
        //Change the TextField BEFORE the function returns
        textField.text = updatedText
        //Update the button's properties
        updateTipLabelUI()
        updateButtonUI()
        //Return to the TextField its original state, because it WILL change after the executing of this function anyway
        textField.text = originalText
        
        return true
    }
    
    private func updateTipLabelUI() {
        guard let text = newPasswordInputView.inputTextField.text else { return }
        Validator.isPasswordValid(for: text) ?
            newPasswordInputView.hideAlertView() :
            newPasswordInputView.showAlertView()
    }
    
    private func updateButtonUI() {
        if let text1 = newPasswordInputView.inputTextField.text, !text1.isEmpty,
           let text2 = confirmNewPasswordInputView.inputTextField.text, !text2.isEmpty,
           text1.count == text2.count {
            self.confirmButton.isEnabled = true
        } else {
            self.confirmButton.isEnabled = false
        }
    }
    
    private func arePasswordsValid() -> Bool {
        let passwrod = newPasswordInputView.inputTextField.text
        let confirmPassword = confirmNewPasswordInputView.inputTextField.text
        
        guard passwrod != "", confirmPassword != "" else { return false }
        guard passwrod == confirmPassword else { return false }
        
        return true
    }
    
    @objc private func onPressConfirm() {
        if arePasswordsValid() {
            Task {
                guard let password = newPasswordInputView.inputTextField.text else { return }
                try await authAPI.updatePassword(with: password) {
                    self.showConfirmView(confirmedAction: { [weak self] in
                        if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                            sceneDelegate.checkAuthentication()
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                }
            }
        } else {
            newPasswordInputView.showBorderAlertView()
            confirmNewPasswordInputView.showAlertView()
        }
    }

}
