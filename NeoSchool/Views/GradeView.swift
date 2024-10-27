import UIKit
import SnapKit

class GradeView: UIView {

    var subtitleText: String? {
        didSet {
            subtitleLabel.text = subtitleText
        }
    }

    private var gradeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = AppFont.font(type: .Regular, size: 14)
        label.numberOfLines = 0
        label.text = "Оценка"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        
        addSubview(gradeLabel)
        gradeLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.width.equalTo(48)
        }

        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(gradeLabel.snp.bottom).offset(4)
            make.bottom.left.right.equalToSuperview()
        }
    }

    func setGrade(grade: Grade, isRounded: Bool) {
        gradeLabel.text = grade.rawValue
        gradeLabel.textColor = isRounded ? .white : grade.color
        
        switch isRounded {
        case true:
            gradeLabel.backgroundColor = grade.color
            gradeLabel.font = AppFont.font(type: .SemiBold, size: 20)
            gradeLabel.textColor = .white
            gradeLabel.layer.cornerRadius = 24
        case false:
            gradeLabel.backgroundColor = .neobisGray
            gradeLabel.font = AppFont.font(type: .Bold, size: 32)
            gradeLabel.textColor = grade.color
            gradeLabel.layer.cornerRadius = 8
        }
        
    }
}
