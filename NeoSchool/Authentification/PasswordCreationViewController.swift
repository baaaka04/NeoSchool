import UIKit
import SnapKit

class PasswordCreationViewController: DetailViewController, Confirmable, UITextFieldDelegate {
    
    private let authAPI: AuthService
    
    private let titleLabel: BigSemiBoldUILabel = {
        let label = BigSemiBoldUILabel()
        label.text = "Создание пароля"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var newPasswordInput: CustomTextField = {
        let textField = CustomTextField(fieldType: .password)
        textField.placeholder = "Новый пароль"
        textField.layer.borderColor = UIColor.neobisRed.cgColor
        textField.delegate = self
        return textField
    }()
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "Минимум 8 символов, включая цифры и спецсимволы (!, \", #, $ и т.д.)"
        label.font = AppFont.font(type: .Medium, size: 16)
        label.textColor = .neobisLightGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var confirmNewPasswordInput: CustomTextField = {
        let textField = CustomTextField(fieldType: .password)
        textField.placeholder = "Новый пароль еще раз"
        textField.layer.borderColor = UIColor.neobisRed.cgColor
        textField.delegate = self
        return textField
    }()
    
    private let errorLabel: UILabel = {
       let label = UILabel()
        label.text = "Пароли не совпадают"
        label.font = AppFont.font(type: .Medium, size: 16)
        label.textColor = .neobisRed
        label.isHidden = true
        return label
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .neobisLightPurple
        button.layer.cornerRadius = 16
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
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(newPasswordInput)
        view.addSubview(tipLabel)
        view.addSubview(confirmNewPasswordInput)
        view.addSubview(errorLabel)
        view.addSubview(confirmButton)
                
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        newPasswordInput.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(52)
        }
        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(newPasswordInput.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-16)
        }
        confirmNewPasswordInput.snp.makeConstraints { make in
            make.top.equalTo(tipLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(52)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmNewPasswordInput.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-16)
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(52)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Hide both of the TextFields red border every time the user change it
        newPasswordInput.layer.borderColor = UIColor.neobisPurple.cgColor
        confirmNewPasswordInput.layer.borderColor = UIColor.neobisPurple.cgColor
        errorLabel.isHidden = true
        
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
        guard let text = newPasswordInput.text else { return }
        tipLabel.textColor = Validator.isPasswordValid(for: text) ? .neobisLightGray : .neobisRed
    }
    
    private func updateButtonUI() {
        if let text1 = newPasswordInput.text, !text1.isEmpty,
           let text2 = confirmNewPasswordInput.text, !text2.isEmpty,
           text1.count == text2.count {
            self.confirmButton.isEnabled = true
            self.confirmButton.backgroundColor = .neobisPurple
        } else {
            self.confirmButton.isEnabled = false
            self.confirmButton.backgroundColor = .neobisLightPurple
        }
    }
    
    private func arePasswordsValid() -> Bool {
        let passwrod = newPasswordInput.text
        let confirmPassword = confirmNewPasswordInput.text
        
        guard passwrod != "", confirmPassword != "" else { return false }
        guard passwrod == confirmPassword else { return false }
        
        return true
    }
    
    @objc private func onPressConfirm() {
        if arePasswordsValid() {
            Task {
                guard let password = newPasswordInput.text else { return }
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
            newPasswordInput.layer.borderColor = UIColor.neobisRed.cgColor
            confirmNewPasswordInput.layer.borderColor = UIColor.neobisRed.cgColor
            newPasswordInput.layer.borderWidth = 1
            confirmNewPasswordInput.layer.borderWidth = 1
            errorLabel.isHidden = false
        }
    }

}
