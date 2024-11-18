import SnapKit
import UIKit

class StudentLessonCollectionViewCell: LessonCollectionViewCell {
    static let identifier = "SubjectCollectionViewCell"

    var descr: String? {
        didSet {
            descrLabel.text = descr
        }
    }

    private let descrLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .mediumItalic, size: 16)
        label.textColor = .neobisBlue
        return label
    }()

    private var gradeView = GradeView()

    func setGrade(to grade: Grade) {
        self.gradeView.setGrade(grade: grade, isRounded: false)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI () {
        contentView.addSubview(gradeView)
        let gradeViewWidth = CGFloat(48)
        gradeView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(72)
            make.width.equalTo(gradeViewWidth)
        }

        contentView.addSubview(descrLabel)
        descrLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
    }
}
