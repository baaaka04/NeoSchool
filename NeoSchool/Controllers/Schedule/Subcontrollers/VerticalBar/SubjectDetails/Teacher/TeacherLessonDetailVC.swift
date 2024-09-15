import UIKit
import SnapKit

class TeacherLessonDetailVC: DetailTitledViewController {

    private let vm: TeacherDetailsViewModel

    private let scrollview = UIScrollView()
    private let timeAndRoomLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let classInfoLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 16))
    private let lineView = UIView()

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
        button.titleLabel?.font = AppFont.font(type: .Medium, size: 18)
        button.addTarget(self, action: #selector(onTapStudentListButton), for: .touchUpInside)
        return button
    }()
    
    private let homeworkPanel = TeacherHomeworkPanelViewController()
    
    private let recievedHomeworksLabel: GrayUILabel = {
        let label = GrayUILabel(font: AppFont.font(type: .Regular, size: 20))
        label.text = "Присланные задания:"
        return label
    }()

    init(viewModel: TeacherDetailsViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollview)
        scrollview.addSubview(timeAndRoomLabel)
        scrollview.addSubview(classInfoLabel)
        scrollview.addSubview(openStudentsListButton)
        addChild(homeworkPanel)
        scrollview.addSubview(homeworkPanel.view)
        homeworkPanel.didMove(toParent: self)
        scrollview.addSubview(recievedHomeworksLabel)
        scrollview.addSubview(lineView)

        addChild(submissionsListVC)
        scrollview.addSubview(submissionsListVC.view)
        submissionsListVC.didMove(toParent: self)

        setupUI()
        getLessonDetails()
    }

    private func setupUI () {
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
        homeworkPanel.view.snp.makeConstraints { make in
            make.top.equalTo(openStudentsListButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
        }
        recievedHomeworksLabel.snp.makeConstraints { make in
            make.top.equalTo(homeworkPanel.view.snp.bottom).offset(16)
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
        homeworkPanel.view.addGestureRecognizer(tapGesture)
        homeworkPanel.attachedFilesLabel.addTarget(self, action: #selector(onTapAttachedFiles), for: .touchUpInside)
    }
    
    func updateUI() {

        guard let lessonDetails = vm.lessonDetails else { return }
        titleLabel.text = lessonDetails.subject.name

        let startTime = try? vm.convertDateStringToHoursAndMinutes(from: lessonDetails.startTime, dateFormat: .short)
        let endTime = try? vm.convertDateStringToHoursAndMinutes(from: lessonDetails.endTime, dateFormat: .short)

        let timeAndRoomText = "\(startTime ?? "") - \(endTime ?? "") · Кабинет: \(lessonDetails.room.name)"
        timeAndRoomLabel.text = timeAndRoomText
        let classInfoText = "\(lessonDetails.grade.name) класс · Учеников: \(lessonDetails.studentsCount)"
        classInfoLabel.text = classInfoText

        let deadline = lessonDetails.homework?.deadline ?? ""
        if let deadlineString = try? vm.convertDateStringToDay(from: deadline, dateFormat: .short) {
            homeworkPanel.deadlineText = "Срок сдачи: \(deadlineString)"
            homeworkPanel.homeworkText = lessonDetails.homework?.text
            homeworkPanel.attachedFilesNumber = lessonDetails.homework?.filesCount
        }
        homeworkPanel.updateUI()

        updateSubmissionsUI()
    }

    private func updateSubmissionsUI() {
        if let submissions = vm.lessonDetails?.submissions, !submissions.isEmpty {
            submissionsListVC.items = submissions.map { TeacherClassItem(submission: $0) }
            submissionsListVC.gradeName = vm.lessonDetails?.grade.name
            submissionsListVC.view.snp.updateConstraints { $0.height.equalTo(20+submissions.count*94) }
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
