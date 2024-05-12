import UIKit
import SnapKit

class CommentView: UIView {
    
    // MARK: - Properties
    
    private let titleLabel: GrayUILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .Medium, size: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: GrayUILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .Regular, size: 16)
        label.text = "-"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(contentLabel)
                    
        layer.borderColor = UIColor.neobisGray.cgColor
        layer.cornerRadius = 16.0
        layer.borderWidth = 1.0
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
    }
    
    // MARK: - Public Methods
    
    func configure(author: CommentAuthor, content: String?) {
        titleLabel.text = author.getText()
        contentLabel.text = content ?? "-"
        
        layoutIfNeeded()
    }
    
}

enum CommentAuthor {
    case mineAsStudent, mineAsTeacher, student, teacher

    func getText() -> String {
        switch self {
            
        case .mineAsStudent:
            return "Мой комментарий:"
        case .mineAsTeacher:
            return "Ваш комментарий:"
        case .student:
            return "Комментарий ученика:"
        case .teacher:
            return "Комментарий учителя:"
        }
    }
}
