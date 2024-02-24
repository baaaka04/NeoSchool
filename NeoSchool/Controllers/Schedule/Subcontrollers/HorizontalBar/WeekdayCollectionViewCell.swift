import UIKit
import SnapKit

class WeekdayCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeekdayCollectionViewCell"
    
    var id: Int? = nil
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                contentView.backgroundColor = .neobisGreen
            } else {
                contentView.backgroundColor = .clear
            }
        }
    }
    
    var title : String? {
        didSet {titleLabel.text = title?.uppercased()}
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Jost-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var subtitle : String? {
        didSet { subtitleLabel.text = subtitle}
    }
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Jost-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(4)
            make.top.left.greaterThanOrEqualToSuperview()
        }

        addSubview(subtitleLabel)

        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.top.left.greaterThanOrEqualToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
