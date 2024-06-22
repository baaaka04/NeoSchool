import UIKit
import SnapKit

class ProfileSubmitView: UIView {
    
    var changePassword: (() -> Void)?
    var logout: (() -> Void)?
    
    private let titleLable: UILabel = {
        let label = GrayUILabel()
        label.text = "Ещё"
        label.font = AppFont.font(type: .Medium, size: 22)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Изменить пароль", for: .normal)
        button.setTitleColor(.neobisDarkGray, for: .normal)
        button.titleLabel?.font = AppFont.font(type: .Regular, size: 20)
        button.setImage(UIImage(named: "lock"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(onTapChangePassword), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Выйти из аккаунта", for: .normal)
        button.setTitleColor(.neobisRed, for: .normal)
        button.titleLabel?.font = AppFont.font(type: .Regular, size: 20)
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(onTapLogout), for: .touchUpInside)
        return button
    }()
    
    private let grabber: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .neobisExtralightGray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private struct Constants {
        static let gap: CGFloat = 12
        static let horizontalPadding: CGFloat = 32
        static let buttonHeight: CGFloat = 60
    }
    
    private func setupUI () {
        
        addSubview(grabber)
        addSubview(titleLable)
        addSubview(changePasswordButton)
        addSubview(logoutButton)
                
        layer.cornerRadius = 32
        backgroundColor = .white
        
        grabber.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(6)
            make.top.equalToSuperview().offset(8)
        }
        titleLable.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(26)
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.top.equalTo(grabber.snp.bottom).offset(Constants.gap)
        }
        changePasswordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.buttonHeight)
            make.top.equalTo(titleLable.snp.bottom).offset(Constants.gap)
        }
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.buttonHeight)
            make.top.equalTo(changePasswordButton.snp.bottom).offset(Constants.gap)
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
    @objc func onTapChangePassword() {
        changePassword?()
    }
    
    @objc func onTapLogout() {
        logout?()
    }
}
