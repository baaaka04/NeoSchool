import SnapKit
import UIKit

class SmallGradeCell: UICollectionViewCell {
    static let identifier = "SmallGradeCell"

    var gradeName: String? {
        didSet {
            gradeLabel.text = gradeName ?? "-"
        }
    }

    var selectedBackgroundColor: UIColor? {
        didSet {
            contentView.backgroundColor = selectedBackgroundColor ?? .neobisExtralightGray
        }
    }

    private let gradeLabel = GrayUILabel(font: AppFont.font(type: .regular, size: 16))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .neobisExtralightGray
        contentView.layer.cornerRadius = 12
        gradeLabel.numberOfLines = 1
        gradeLabel.textAlignment = .center
        gradeLabel.text = "-"

        contentView.addSubview(gradeLabel)
        gradeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.right.left.equalToSuperview().inset(8.5)
        }
    }
}
