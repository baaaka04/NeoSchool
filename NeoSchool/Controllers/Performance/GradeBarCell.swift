import UIKit
import SnapKit

class GradesBarCell: UICollectionViewCell {
    static let identifier = "GradesBarCell"

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                contentView.backgroundColor = .neobisPurple
            } else {
                contentView.backgroundColor = .clear
            }
        }
    }

    var gradeNameText: String? {
        didSet {
            gradeNameLabel.text = gradeNameText
        }
    }

    private let gradeNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Bold, size: 20)
        label.textColor = .white
        label.textAlignment = .center
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
        contentView.layer.cornerRadius = 8
        contentView.addSubview(gradeNameLabel)
        gradeNameLabel.snp.makeConstraints { $0.edges.centerX.centerY.equalToSuperview() }
    }
}
