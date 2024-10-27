import UIKit
import SnapKit


class LastMarksCell: UICollectionViewCell {
    static let identifier: String = "LastMarksCell"

    var grade: Grade? {
        didSet {
            self.titleLabel.text = grade?.rawValue
            self.titleLabel.textColor = grade?.color
            self.contentView.backgroundColor = grade?.backgroundColor
        }
    }

    private let titleLabel = GrayUILabel(font: AppFont.font(type: .SemiBold, size: 20))

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        contentView.layer.cornerRadius = 8
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}
