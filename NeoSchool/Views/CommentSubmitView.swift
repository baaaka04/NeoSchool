import UIKit
import SnapKit

class CommentSubmitView: UIView {
    
    var uploadFiles: (() -> Void)?
    
    private let titleLable: UILabel = {
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
        input.counterInsets = UIEdgeInsets(top: Constants.inputHeight-34, left: 16, bottom: 12, right: 16)
        input.limit = 100
        return input
    }()
    
    lazy var submitButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Сдать", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(uploadFilesButtonTapped), for: .touchUpInside)
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
        static let gap: CGFloat = 24
        static let horizontalPadding: CGFloat = 32
        static let inputHeight: CGFloat = 158
    }
    
    private func setupUI () {
        
        addSubview(grabber)
        addSubview(titleLable)
        addSubview(commentInput)
        addSubview(submitButton)
                
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
        commentInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.inputHeight)
            make.top.equalTo(titleLable.snp.bottom).offset(Constants.gap)
        }
        submitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(52)
            make.top.equalTo(commentInput.snp.bottom).offset(Constants.gap)
        }
    }
    
    @objc func uploadFilesButtonTapped() {
        uploadFiles?()
    }
}
