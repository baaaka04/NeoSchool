import SnapKit
import UIKit

class WeekdayCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeekdayCollectionViewCell"

    var id: Int?

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

    var title: String? {
        didSet {titleLabel.text = title?.uppercased()}
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .bold, size: 16)
        label.textColor = .neobisGray
        label.textAlignment = .center
        return label
    }()

    var subtitle: String? {
        didSet { subtitleLabel.text = subtitle}
    }

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .semiBold, size: 12)
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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
