import UIKit
import SnapKit

class AlertPasswordInputView: UIView {

    let inputTextField = CustomTextField(fieldType: .password)
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 16)
        label.textColor = .neobisLightGray
        label.numberOfLines = 0
        return label
    }()
    
    private var isHintHidden: Bool
    
    init(placeholder: String, hintText: String, isHintHidden: Bool) {
        self.isHintHidden = isHintHidden
        
        super.init(frame: .zero)
        
        inputTextField.placeholder = placeholder
        hintLabel.text = hintText
        hintLabel.isHidden = isHintHidden
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(inputTextField)
        addSubview(hintLabel)
        
        inputTextField.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(52)
        }
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func showBorderAlertView() {
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.borderColor = UIColor.neobisRed.cgColor
    }
    
    func showAlertView() {
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.borderColor = UIColor.neobisRed.cgColor
        hintLabel.textColor = UIColor.neobisRed
        hintLabel.isHidden = false
    }
    
    func hideAlertView() {
        inputTextField.layer.borderColor = UIColor.neobisPurple.cgColor
        hintLabel.textColor = UIColor.neobisLightGray
        hintLabel.isHidden = isHintHidden
    }
    
}
