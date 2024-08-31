import UIKit

class LoginTextField: NeobisTextField {

    enum LoginTextField {
        case username
        case email
        case password
    }
        
    private var isPasswordHidden: Bool = true
    
    lazy var imageIcon : UIImageView = {
        let image = UIImage(named: "EyeIcon")?.withTintColor(.neobisLightGray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    lazy var eyeImageViewContainer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: imageIcon.frame.width+12, height: imageIcon.frame.height))
        view.addSubview(imageIcon)
        return view
    }()
        
    private let authTextFieldType: LoginTextField

    init(fieldType: LoginTextField) {
        self.authTextFieldType = fieldType
        super.init(frame: .zero)

        switch fieldType {
        case .email:
            self.placeholder = "Электронная почта"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Пароль"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
            self.rightView = eyeImageViewContainer
            self.rightViewMode = .always
        case .username:
            self.placeholder = "Логин"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTapImage(tgr: UITapGestureRecognizer) {
        let tappedImage = tgr.view as? UIImageView
        
        if isPasswordHidden {
            isPasswordHidden = false
            tappedImage?.image = UIImage(named: "EyeSlashIcon")?.withTintColor(.neobisLightGray, renderingMode: .alwaysOriginal)
            self.isSecureTextEntry = false
        } else {
            isPasswordHidden = true
            tappedImage?.image = UIImage(named: "EyeIcon")?.withTintColor(.neobisLightGray, renderingMode: .alwaysOriginal)
            self.isSecureTextEntry = true
        }
    }

}
