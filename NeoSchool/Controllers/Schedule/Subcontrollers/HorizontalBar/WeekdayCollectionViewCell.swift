import UIKit
import SnapKit

class WeekdayCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeekdayCollectionViewCell"
    
    var id: Int? = nil
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                contentView.backgroundColor = selectedColor
            } else {
                contentView.backgroundColor = .clear
            }
        }
    }

    var selectedColor: UIColor = .neobisGreen

    var title : String? {
        didSet {titleLabel.text = title?.uppercased()}
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Bold, size: 16)
        label.textColor = .neobisGray
        label.textAlignment = .center
        return label
    }()
    
    var subtitle : String? {
        didSet { subtitleLabel.text = subtitle}
    }
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .SemiBold, size: 12)
        label.textColor = .neobisGray
        label.textAlignment = .center
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
