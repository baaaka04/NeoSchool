import UIKit
import SnapKit

class SnackBarView: UIView {
    
    let isSucceed: Bool
    let text: String
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = AppFont.font(type: .Regular, size: 20)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    init(text: String, isSucceed: Bool) {
        self.isSucceed = isSucceed
        self.text = text
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        addSubview(iconView)
        addSubview(titleLabel)
        
        layer.cornerRadius = 16
        
        if isSucceed {
            backgroundColor = .neobisGreen
            iconView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            backgroundColor = .neobisSnackbarRed
            iconView.image = UIImage(systemName: "exclamationmark.circle.fill")
        }
        self.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
        }
    }

}
