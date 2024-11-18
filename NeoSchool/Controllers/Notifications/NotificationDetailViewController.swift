import SnapKit
import UIKit

class NotificationDetailViewController: DetailViewController {
    private weak var viewModel: NotificationsViewModel?
    private let notification: NeobisNotificationToPresent

    private lazy var textLabel: GrayUILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .medium, size: 20)
        label.numberOfLines = 0
        label.text = notification.text
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .regular, size: 16)
        label.textColor = .neobisLightGray
        label.text = notification.date
        return label
    }()

    private lazy var teacherCommentView: CommentView = {
        CommentView(author: .teacher, text: notification.teacherComment)
    }()

    private lazy var navigateButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        switch notification.type {
        case .rateHomework, .submitHomework, .reviseHomework:
            button.setTitle("Просмотреть задание", for: .normal)
        case .rateQuater, .rateClasswork:
            button.setTitle("Просмотреть оценки по этому предмету", for: .normal)
        }
        button.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }
        return button
    }()

    init(viewModel: NotificationsViewModel?, notification: NeobisNotificationToPresent) {
        self.viewModel = viewModel
        self.notification = notification

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        checkAsRead()
    }

    private func setupUI() {
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        }

        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(24)
            make.width.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        }
        if self.notification.type == .rateHomework {
            view.addSubview(teacherCommentView)
            teacherCommentView.snp.makeConstraints { make in
                make.top.equalTo(dateLabel.snp.bottom).offset(24)
                make.width.equalToSuperview().inset(32)
                make.centerX.equalToSuperview()
            }
        }
        let lastConstraint = self.notification.type == .rateHomework ? teacherCommentView.snp.bottom : dateLabel.snp.bottom

        view.addSubview(navigateButton)
        navigateButton.snp.makeConstraints { make in
            make.top.equalTo(lastConstraint).offset(24)
            make.width.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func onTapButton() {
        switch self.notification.type {
        case .rateHomework:
            openLessonDetails()
        case .rateClasswork:
            openQuaterMarks()
        case .reviseHomework:
            openLessonDetails()
        case .rateQuater:
            openQuaterMarks()
        case .submitHomework:
            openStudentSubmission()
        }
    }

    private func checkAsRead() {
        Task {
            do {
                try await viewModel?.checkAsRead(notificationId: notification.id)
            } catch {print(error) }
        }
    }

    private let scheduleAPI = DayScheduleAPI()
    private let performanceAPI = PerformanceAPI()

    private func openStudentSubmission() {
        guard let submissionId = notification.submissionId else { return }
        let vm = TeacherDetailsViewModel(lessonId: 1, teacherAPI: scheduleAPI)
        let submissionDetailsVC = StudentHomeworkDetailsViewController(submissionId: submissionId, editable: true, vm: vm)
        let studentFullName = notification.studentName

        if let words = studentFullName?.components(separatedBy: " "),
           words.count >= 2 {
            submissionDetailsVC.titleText = "\(words[0]) \(words[1])"
        }
        self.navigationController?.pushViewController(submissionDetailsVC, animated: true)
    }

    private func openLessonDetails() {
        guard let lessonId = notification.lessonId else { return }
        let viewModel = SubjectDetailsViewModel(lessonId: lessonId, lessonAPI: scheduleAPI)
        let studentLessonDetailsVC = SubjectDetailsStatefulViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(studentLessonDetailsVC, animated: true)
    }

    private func openQuaterMarks() {
        guard let quater = notification.quater,
              let subjectId = notification.subjectId else { return }
        let lastMakrsDetailsVC = LastMarksDetailsVC(performanceAPI: performanceAPI, quater: quater, subjectId: subjectId)
        lastMakrsDetailsVC.titleText = notification.subjectName
        lastMakrsDetailsVC.title = "Последние оценки"
        self.navigationController?.pushViewController(lastMakrsDetailsVC, animated: true)
    }
}
