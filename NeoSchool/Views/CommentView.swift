import UIKit
import SnapKit

class CommentView: UIView {
    
    var uploadFiles: (() -> Void)?
    
    lazy var titleLable: UILabel = {
        let label = GrayUILabel()
        label.text = "Сдать задание"
        label.font = AppFont.font(type: .Medium, size: 22)
        label.textAlignment = .center
        return label
    }()
    
    let commentInput: PlaceholderTextView = {
        let input = PlaceholderTextView()
        input.placeholder = "Комментарий (необязательно)"
        input.placeholderInsets = UIEdgeInsets(top: 12, left: 16, bottom: Constants.inputHeight-34, right: 16)
        input.placeholderLabel.font = AppFont.font(type: .Regular, size: 20)
        input.counterInsets = UIEdgeInsets(top: Constants.inputHeight-34, left: 16, bottom: 12, right: 16)
        input.counterLabel.font = AppFont.font(type: .Regular, size: 12)
        input.counterLabel.textAlignment = .right
        input.limit = 100
        input.layer.cornerRadius = 16
        input.font = AppFont.font(type: .Regular, size: 18)
        input.backgroundColor = UIColor.neobisExtralightGray
        return input
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сдать", for: .normal)
        button.backgroundColor = .neobisPurple
        button.layer.cornerRadius = 16
        button.titleLabel?.font = AppFont.font(type: .Regular, size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(uploadFilesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let grabber: UIImageView = {
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

    struct Constants {
        static let gap: CGFloat = 24
        static let horizontalPadding: CGFloat = 32
        static let inputHeight: CGFloat = 108
    }
    
    private func setupUI () {
        
        addSubview(submitButton)
        addSubview(commentInput)
        addSubview(titleLable)
        addSubview(grabber)
                
        layer.cornerRadius = 32
        backgroundColor = .white
        
        submitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-52)
        }
        commentInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.inputHeight)
            make.bottom.equalTo(submitButton.snp.top).offset(-Constants.gap)
        }
        titleLable.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(26)
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalTo(commentInput.snp.top).offset(-Constants.gap)
        }
        grabber.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(6)
            make.bottom.equalTo(titleLable.snp.top).offset(-Constants.gap)
        }
    }
    
    @objc func uploadFilesButtonTapped() {
        uploadFiles?()
    }
}
