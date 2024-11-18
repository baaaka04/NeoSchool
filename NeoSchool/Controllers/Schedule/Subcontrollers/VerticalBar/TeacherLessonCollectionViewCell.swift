import SnapKit
import UIKit

class TeacherLessonCollectionViewCell: LessonCollectionViewCell {
    static let identifier = "TeacherLessonCollectionViewCell"

    var subjectName: String? {
        didSet {
            guard let subjectName else { return }
            subjectNameLabel.text = subjectName + " · "
        }
    }

    private let subjectNameLabel: GrayUILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .medium, size: 16)
        return label
    }()

    var homeworkCount: Int? {
        didSet {
            if let homeworkCount {
                homeworkCountLabel.text = " Заданий прислано: \(homeworkCount)"
                homeworkCountLabel.textColor = .neobisBlue
            } else {
                homeworkCountLabel.text = " Задание не задано"
                homeworkCountLabel.textColor = .neobisRed
            }
        }
    }

    private let homeworkCountLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .medium, size: 16)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI () {
        contentView.addSubview(subjectNameLabel)
        subjectNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.width.lessThanOrEqualTo(80)
        }
        contentView.addSubview(homeworkCountLabel)
        homeworkCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(subjectNameLabel.snp.trailing)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
        }
    }
}
