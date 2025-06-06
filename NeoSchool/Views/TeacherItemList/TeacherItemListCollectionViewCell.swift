import SnapKit
import UIKit

class TeacherItemListCollectionViewCell: UICollectionViewCell {
    static let identifier = "TeacherItemListCollectionViewCell"

    var id: Int?

    var title: String? {
        didSet { titleLabel.text = title }
    }

    private let titleLabel: GrayUILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .medium, size: 18)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    var subtitle: String? {
        didSet { subtitleLabel.text = subtitle }
    }

    var attributedSubtitle: NSAttributedString? {
        didSet { subtitleLabel.attributedText = attributedSubtitle }
    }

    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .regular, size: 16))

    var datetimeText: String? {
        didSet { self.datetimeLabel.text = datetimeText }
    }

    private let datetimeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .regular, size: 16)
        label.textColor = .neobisLightGray
        return label
    }()

    private let arrowRightView = UIImageView(image: UIImage(named: Asset.regularchevronRight))

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let containerView = ContainerView()

        contentView.addSubview(containerView)
        containerView.addSubview(arrowRightView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(datetimeLabel)

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
        }
        datetimeLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
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
        contentView.layer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func removeArrow() {
        arrowRightView.removeFromSuperview()
    }
}
