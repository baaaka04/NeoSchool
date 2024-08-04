import UIKit
import SnapKit

class StudentsListCollectionViewCell: UICollectionViewCell {
    static let identifier = "StudentsListCollectionViewCell"
    
    var id: Int? = nil
    
    var studentName : String? {
        didSet { titleLabel.text = studentName }
    }
    
    private let titleLabel: GrayUILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .Medium, size: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var homeworkCount : String? {
        didSet { subtitleLabel.text = homeworkCount }
    }
    
    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    
    private let arrowRightView = UIImageView(image: UIImage(named: "regularchevron-right"))
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let containerView = UIView()
        
        contentView.addSubview(containerView)
        containerView.addSubview(arrowRightView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)

        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.neobisShadow.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 10
        containerView.layer.masksToBounds = false

        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(6)
        }
        arrowRightView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(arrowRightView.snp.left).inset(16)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(arrowRightView.snp.left).inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let collectionViewWidth = UIScreen.main.bounds.width
        let targetWidth = collectionViewWidth
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
