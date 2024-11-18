import SnapKit
import UIKit

class TeacherLessonDetailVC: DetailTitledViewController {
    private let vm: TeacherDetailsViewModel

    private let scrollview = UIScrollView()
    private let timeAndRoomLabel = GrayUILabel(font: AppFont.font(type: .regular, size: 16))
    private let classInfoLabel = GrayUILabel(font: AppFont.font(type: .medium, size: 16))
    private let lineView = UIView()
    private let homeworkPanel = HomeworkPanelView(presentaionMode: .teacherFull)
    private lazy var submissionsListVC = SubmissionsListVC(vm: self.vm)

    private lazy var openStudentsListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Просмотреть учеников", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.neobisGreen, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.neobisGreen.cgColor
        button.titleLabel?.snp.makeConstraints { $0.width.equalToSuperview().offset(-30) }
        button.titleLabel?.font = AppFont.font(type: .medium, size: 18)
        button.addTarget(self, action: #selector(onTapStudentListButton), for: .touchUpInside)
        return button
    }()

    private let recievedHomeworksLabel: GrayUILabel = {
        let label = GrayUILabel(font: AppFont.font(type: .regular, size: 20))
        label.text = "Присланные задания:"
        return label
    }()

    init(viewModel: TeacherDetailsViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getLessonDetails()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLessonDetails()
    }

    private func setupUI () {
        view.addSubview(scrollview)
        scrollview.showsVerticalScrollIndicator = false

        addChild(submissionsListVC)
        scrollview.addSubview(submissionsListVC.view)
        submissionsListVC.didMove(toParent: self)

        [timeAndRoomLabel, classInfoLabel, openStudentsListButton, homeworkPanel, recievedHomeworksLabel, lineView]
            .forEach { scrollview.addSubview($0) }

        lineView.backgroundColor = .neobisGrayStroke
        scrollview.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        timeAndRoomLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        classInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(timeAndRoomLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        openStudentsListButton.snp.makeConstraints { make in
            make.top.equalTo(classInfoLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }
        homeworkPanel.snp.makeConstraints { make in
            make.top.equalTo(openStudentsListButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
        }
        recievedHomeworksLabel.snp.makeConstraints { make in
            make.top.equalTo(homeworkPanel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(recievedHomeworksLabel.snp.bottom).offset(16)
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        submissionsListVC.view.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapHomework))
        homeworkPanel.addGestureRecognizer(tapGesture)
        homeworkPanel.attachedFilesLabel.addTarget(self, action: #selector(onTapAttachedFiles), for: .touchUpInside)
    }

    func updateUI() {
        guard let lessonDetails = vm.lessonDetails else { return }
        titleLabel.text = lessonDetails.subject.name

        let startTime = try? DateConverter.convertDateStringToHoursAndMinutes(from: lessonDetails.startTime, dateFormat: .short)
        let endTime = try? DateConverter.convertDateStringToHoursAndMinutes(from: lessonDetails.endTime, dateFormat: .short)

        let timeAndRoomText = "\(startTime ?? "") - \(endTime ?? "") · Кабинет: \(lessonDetails.room.name)"
        timeAndRoomLabel.text = timeAndRoomText
        let classInfoText = "\(lessonDetails.grade.name) класс · Учеников: \(lessonDetails.studentsCount)"
        classInfoLabel.text = classInfoText

        let deadline = lessonDetails.homework?.deadline ?? ""
        if let deadlineString = try? DateConverter.convertDateStringToDay(from: deadline, dateFormat: .short) {
            homeworkPanel.deadlineText = "Срок сдачи: \(deadlineString)"
            homeworkPanel.homeworkText = lessonDetails.homework?.text
            homeworkPanel.attachedFilesNumber = lessonDetails.homework?.filesCount
        }

        updateSubmissionsUI()
    }

    private func updateSubmissionsUI() {
        if let submissions = vm.lessonDetails?.submissions, !submissions.isEmpty {
            submissionsListVC.items = submissions.map { TeacherClassItem(submission: $0) }
            submissionsListVC.gradeName = vm.lessonDetails?.grade.name
            submissionsListVC.view.snp.updateConstraints { $0.height.equalTo(20 + submissions.count * 94) }
        }
        submissionsListVC.updateUI()
    }

    private func getLessonDetails() {
        Task {
            do {
                try await vm.getLessonDetails()
                updateUI()
                try await vm.getTeacherHomeworkFiles()
            } catch { print(error) }
        }
    }

    @objc func onTapHomework() {
        let setHomeworkVC = SetHomeworkViewController(vm: vm)
        setHomeworkVC.titleText = "Редактировать задание"
        setHomeworkVC.popVC = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            self?.updateUI()
        }
        if let lessonDetails = vm.lessonDetails {
            let subjectAndGradeNames = lessonDetails.subject.name + " · " + lessonDetails.grade.name + " класс"
            setHomeworkVC.subtitleText = subjectAndGradeNames
        }
        self.navigationController?.pushViewController(setHomeworkVC, animated: true)
    }

    @objc func onTapAttachedFiles() {
        guard let urls = vm.attachedFilesURLs else { return }
        let attachedListVC = AttachedFilesDetailViewController(URLs: urls)
        attachedListVC.title = "Прикрепленные материалы"

        self.navigationController?.pushViewController(attachedListVC, animated: true)
    }

    @objc func onTapStudentListButton() {
        let studentListVC = GradeStudentsListViewController(viewModel: self.vm)
        guard let lessonDetails = vm.lessonDetails else { return }
        studentListVC.titleText = "Ученики \(lessonDetails.grade.name) класса"
        studentListVC.subtitleText = "Учеников: \(lessonDetails.studentsCount)"
        self.navigationController?.pushViewController(studentListVC, animated: true)
    }
}
