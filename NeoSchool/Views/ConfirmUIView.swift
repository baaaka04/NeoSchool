import UIKit
import SnapKit

class ConfirmUIView: UIView {
    
    private var title: String
    private var text: String?
    private var confirmButtonText: String
    private var declineButtonText: String
    
    private var confirmedAction: (() -> Void)
    
    private let questionImage = UIImageView(image: UIImage(named: "GreenQuestionMark"))
    
    let modalView : UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.title
        label.textAlignment = .center
        label.font = AppFont.font(type: .Medium, size: 22)
        label.textColor = .neobisDarkGray
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = self.text
        label.textAlignment = .center
        label.font = AppFont.font(type: .Regular, size: 18)
        label.textColor = .neobisDarkGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var confirmButton : NeobisUIButton = {
        let button = NeobisUIButton(type: .red)
        button.setTitle(self.confirmButtonText, for: .normal)
        button.addTarget(self, action: #selector(onPressConfirm), for: .touchUpInside)
        return button
    }()
    
    private lazy var declineButton : UIButton = {
        let button = UIButton()
        button.setTitle(self.declineButtonText, for: .normal)
        button.titleLabel?.font = AppFont.font(type: .Regular, size: 20)
        button.setTitleColor(.neobisDarkGray, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        return button
    }()
    
    init(title: String, text: String? = nil, confirmButtonText: String, declineButtonText: String, confirmedAction: @escaping (() -> Void)) {
        self.title = title
        self.text = text
        self.confirmButtonText = confirmButtonText
        self.declineButtonText = declineButtonText
        self.confirmedAction = confirmedAction
        super.init(frame: .zero)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
        self.addGestureRecognizer(tapGesture)
        
        addSubview(modalView)
        
        modalView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(500)
            make.width.equalToSuperview().offset(-32)
        }
        
        modalView.addSubview(questionImage)
        modalView.addSubview(titleLabel)
        
        if text != nil { modalView.addSubview(textLabel) }
        
        modalView.addSubview(confirmButton)
        modalView.addSubview(declineButton)
                
        questionImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.width.equalTo(77)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(questionImage.snp.bottom).offset(Constants.gap)
            make.left.equalToSuperview().offset(Constants.horizantalMargin)
            make.right.equalToSuperview().offset(-Constants.horizantalMargin)
        }
        if text != nil {
            textLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(Constants.gap)
                make.left.equalToSuperview().offset(Constants.horizantalMargin)
                make.right.equalToSuperview().offset(-Constants.horizantalMargin)
            }
        }
        let lastConstraint : ConstraintItem = {
            if text != nil {
                return textLabel.snp.bottom
            } else {
                return titleLabel.snp.bottom
            }
        }()
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(lastConstraint).offset(Constants.gap)
            make.left.equalToSuperview().offset(Constants.horizantalMargin)
            make.right.equalToSuperview().offset(-Constants.horizantalMargin)
            make.height.equalTo(Constants.buttonHeight)
        }
        declineButton.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(Constants.gap/2)
            make.left.equalToSuperview().offset(Constants.horizantalMargin)
            make.right.equalToSuperview().offset(-Constants.horizantalMargin)
            make.height.equalTo(Constants.buttonHeight)
            make.bottom.equalToSuperview().offset(-Constants.horizantalMargin)
        }
        
    }
    
    func removeWithAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.modalView.snp.updateConstraints { $0.bottom.equalToSuperview().offset(500) }
            self.layoutIfNeeded()
        } completion: {_  in
            self.removeFromSuperview()
        }
    }
    
    @objc private func onPressConfirm() {
        confirmedAction()
        removeWithAnimation()
    }
    
    @objc private func hideView() {
        removeWithAnimation()
    }
    
    private struct Constants {
        static let gap : CGFloat = 24
        static let horizantalMargin : CGFloat = 16
        static let buttonHeight : CGFloat = 52
    }
    
}
