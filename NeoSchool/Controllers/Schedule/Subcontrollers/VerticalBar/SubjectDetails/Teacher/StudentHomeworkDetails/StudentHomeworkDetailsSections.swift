import UIKit
import SnapKit

class FilesCell: AutosizeUICollectionViewCell {

    static let identifier = "FilesCell"

}

class CommentsCell: AutosizeUICollectionViewCell {

    static let identifier = "CommentsCell"

    private lazy var studentComment = CommentView(author: .student, text: nil)
    private lazy var teacherComment = CommentView(author: .mineAsTeacher, text: nil)

    var studentCommentText: String? {
        didSet {
            studentComment.contentText = studentCommentText
        }
    }
    var bottomConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
    }

    private func addSubviews() {
        teacherComment.isHidden = true
        contentView.addSubview(studentComment)
        studentComment.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            self.bottomConstraint = make.bottom.equalToSuperview().constraint
        }
        contentView.addSubview(teacherComment)
        teacherComment.snp.makeConstraints { make in
            make.top.equalTo(studentComment.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTeacherComment(text: String?) {
        if let text {
            self.teacherComment.isHidden = false
            self.teacherComment.contentText = text
            self.bottomConstraint?.deactivate()
        } else {
            self.teacherComment.isHidden = true
            self.bottomConstraint?.activate()
        }
    }

}

class MarkInfoCell: AutosizeUICollectionViewCell {

    static let identifier = "MarkInfoViewCell"

    private let lineView = UIView()
    private let markView = MarkUIView()

    var mark: Grade? {
        didSet {
            markView.mark = mark
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
    }

    private func addSubviews() {
        lineView.backgroundColor = .neobisGrayStroke
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        contentView.addSubview(markView)
        markView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.left.bottom.equalToSuperview()
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class GeneralInfoCell: AutosizeUICollectionViewCell {

    static let identifier = "GeneralInfoViewCell"

    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 16))
    private let firstDesciptionLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let secondDesciptionLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let onTimeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 18)
        label.textColor = .neobisGreen
        return label
    }()

    var subtitleText: String? {
        didSet { subtitleLabel.text = subtitleText }
    }

    var firstDesciptionText: String? {
        didSet { firstDesciptionLabel.text = firstDesciptionText }
    }

    var secondDesciptionText: String? {
        didSet { secondDesciptionLabel.text = secondDesciptionText }
    }

    var onTimeText: String? {
        didSet { onTimeLabel.text = onTimeText }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    private func addSubviews() {
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        contentView.addSubview(firstDesciptionLabel)
        firstDesciptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
        }
        contentView.addSubview(secondDesciptionLabel)
        secondDesciptionLabel.snp.makeConstraints { make in
            make.top.equalTo(firstDesciptionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
        }
        contentView.addSubview(onTimeLabel)
        onTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(secondDesciptionLabel.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class HomeworkCell: AutosizeUICollectionViewCell {

    static let identifier = "HomeworkCell"

    private let homeworkInfo = HomeworkPanelView(presentaionMode: .teacherShort)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    private func addSubviews() {
        contentView.addSubview(homeworkInfo)
        homeworkInfo.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(submission: TeacherSubmissionDetails) {
        homeworkInfo.homeworkText = submission.homework.text
        homeworkInfo.deadlineText = submission.homework.deadline
        homeworkInfo.attachedFilesNumber = submission.homework.filesCount
    }

}
