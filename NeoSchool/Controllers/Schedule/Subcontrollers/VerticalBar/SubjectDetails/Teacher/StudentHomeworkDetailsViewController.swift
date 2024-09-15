import UIKit
import SnapKit

protocol StudentHomeworkProtocol {
    var submissionDetails: TeacherSubmissionDetails? { get set }
    var submissionFilesUrls: [String]? { get set }
    func getSubmissionDetails(submissionId: Int) async throws -> Void
}

class StudentHomeworkDetailsViewController: DetailTitledViewController {

    private var submissionId: Int
    private var vm: StudentHomeworkProtocol?
    private let editable: Bool
    var subtitleText: String? {
        didSet { subtitleLabel.text = subtitleText }
    }

    private let scrollView = UIScrollView()
    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 16))
    private let firstDesciptionLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let secondDesciptionLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let onTimeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 18)
        label.textColor = .neobisGreen
        return label
    }()
    private let homeworkInfo = HomeworkDeadlineViewController()

    private let lineView = UIView()
    private let markView = MarkUIView()

    private let studentFilesVC = FilesCollectionViewController()
    private lazy var studentComment = CommentView(author: .student, text: vm?.submissionDetails?.studentComment)
    private lazy var teacherComment = CommentView(author: .mineAsTeacher, text: vm?.submissionDetails?.teacherComment)

    private lazy var reviseButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .white)
        button.setTitle("Вернуть на доработку", for: .normal)
        button.isHidden = !self.editable
        return button
    }()
    private lazy var gradeButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Выставить оценку", for: .normal)
        button.isHidden = !self.editable
        return button
    }()

    init(submissionId: Int, editable: Bool, vm: StudentHomeworkProtocol?) {
        self.submissionId = submissionId
        self.editable = editable
        self.vm = vm

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getSubmissionDetails()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        lineView.backgroundColor = .neobisGrayStroke
        scrollView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalTo(titleLabel)
        }
        scrollView.addSubview(firstDesciptionLabel)
        firstDesciptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }
        scrollView.addSubview(secondDesciptionLabel)
        secondDesciptionLabel.snp.makeConstraints { make in
            make.top.equalTo(firstDesciptionLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }
        scrollView.addSubview(onTimeLabel)
        onTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(secondDesciptionLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }
        addChild(homeworkInfo)
        scrollView.addSubview(homeworkInfo.view)
        homeworkInfo.didMove(toParent: self)
        homeworkInfo.view.snp.makeConstraints { make in
            make.top.equalTo(onTimeLabel.snp.bottom).offset(16)
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        scrollView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(homeworkInfo.view.snp.bottom).offset(16)
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        scrollView.addSubview(markView)
        markView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.left.right.equalTo(titleLabel)
        }
        scrollView.addSubview(studentComment)
        studentComment.snp.makeConstraints { make in
            make.top.equalTo(markView.snp.bottom).offset(16)
            make.left.right.equalTo(titleLabel)
        }
        scrollView.addSubview(teacherComment)
        teacherComment.snp.makeConstraints { make in
            make.top.equalTo(studentComment.snp.bottom).offset(16)
            make.left.right.equalTo(titleLabel)
        }
        let lastConstraint = (vm?.submissionDetails?.teacherComment != nil) ? teacherComment.snp.bottom : studentComment.snp.bottom
        addChild(studentFilesVC)
        scrollView.addSubview(studentFilesVC.view)
        studentFilesVC.didMove(toParent: self)
        studentFilesVC.view.snp.makeConstraints { make in
            make.top.equalTo(lastConstraint).offset(16)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(52+52+52+12)
        }
        view.addSubview(gradeButton)
        gradeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(52)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(52)
        }
        view.addSubview(reviseButton)
        reviseButton.snp.makeConstraints { make in
            make.bottom.equalTo(gradeButton.snp.top).offset(-12)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(52)
        }
    }

    private func updateUI() {
        guard let submission = vm?.submissionDetails else { return }
        firstDesciptionLabel.text = "\(submission.topic) · Предмет: \(submission.subject.name)"
        secondDesciptionLabel.text = submission.submittedDate
        onTimeLabel.text = submission.submittedOnTime ? "Прислано в срок" : "Срок сдачи пропущен"
        onTimeLabel.textColor = submission.submittedOnTime ? .neobisGreen : .neobisRed
        markView.mark = Grade(rawValue: submission.mark ?? "-")
        studentFilesVC.update(urls: vm?.submissionFilesUrls)
        studentFilesVC.view.snp.updateConstraints { $0.height.equalTo(submission.files.count > 0 ? (64*submission.files.count+(submission.files.count-1)*8) : 0) }
        studentComment.contentText = submission.studentComment
        teacherComment.isHidden = submission.teacherComment == nil
        teacherComment.contentText = submission.teacherComment
        homeworkInfo.homeworkText = submission.homework.text
        homeworkInfo.deadlineText = submission.homework.deadline
        homeworkInfo.attachedFilesNumber = submission.homework.filesCount
        homeworkInfo.updateUI()
    }

    private func getSubmissionDetails() {
        Task {
            do {
                try await vm?.getSubmissionDetails(submissionId: self.submissionId)
                updateUI()
            } catch { print(error) }
        }
    }

}
