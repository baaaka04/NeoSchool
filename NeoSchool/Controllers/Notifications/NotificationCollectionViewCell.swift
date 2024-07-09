import UIKit
import SnapKit

class NotificationCollectionViewCell: UICollectionViewCell {
    static let identifier = "NotificationCollectionViewCell"
    
    var id: Int? = nil
    
    var isRead: Bool? {
        didSet { isReadIndicatorImage.isHidden = isRead ?? false }
    }
    
    private let isReadIndicatorImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "circle.fill"))
        image.tintColor = .neobisGreen
        return image
    }()
    
    var text : String? {
        didSet { textLabel.text = text }
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .neobisDarkGray
        return label
    }()
    
    var date : String? {
        didSet { dateLabel.text = date }
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Regular, size: 16)
        label.textColor = .neobisLightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.neobisShadow.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 10
        contentView.layer.masksToBounds = false
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
                
        contentView.addSubview(isReadIndicatorImage)
        
        isReadIndicatorImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(8)
            make.leading.equalToSuperview().inset(16)
        }
                
        contentView.addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(isReadIndicatorImage.snp.right).offset(12)
        }

        contentView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(8)
            make.left.equalTo(isReadIndicatorImage.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
        
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let collectionViewWidth = UIScreen.main.bounds.width
        let targetWidth = collectionViewWidth - 32 // Adjust this based on your padding/margin requirements
        let targetSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(targetSize,
                                                       withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        newFrame.size.width = ceil(size.width)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update the shadow path when the cell's bounds change
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}
