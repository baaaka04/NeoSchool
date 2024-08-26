import UIKit
import SnapKit

class TeacherLessonDetailVC: DetailTitledViewController {

    private let vm: TeacherDetailsViewModel

    private let timeAndRoomLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let classInfoLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 16))
    private let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .neobisGrayStroke
        return line
    }()
    
    private let noHomeworkView = NotepadView(title: "Пока нет заданий", subtitle: "Ученики пока не присылали работы по данному заданию")
    
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
        
        view.addSubview(timeAndRoomLabel)
        view.addSubview(classInfoLabel)
        view.addSubview(openStudentsListButton)
        addChild(homeworkPanel)
        view.addSubview(homeworkPanel.view)
        didMove(toParent: self)
        view.addSubview(recievedHomeworksLabel)
        view.addSubview(lineView)
        view.addSubview(noHomeworkView)

        setupUI()
        getLessonDetails()
    }
    
    private func setupUI () {
        timeAndRoomLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
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
            make.leading.trailing.equalToSuperview().inset(16)
        }
        recievedHomeworksLabel.snp.makeConstraints { make in
            make.top.equalTo(homeworkPanel.view.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(recievedHomeworksLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        noHomeworkView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapHomework))
        homeworkPanel.view.addGestureRecognizer(tapGesture)
    }
    
    func updateUI() {

        guard let lessonDetails = vm.lessonDetails else { return }
        titleLabel.text = lessonDetails.subject.name

        let startTime = try? vm.convertDateStringToHoursAndMinutes(from: lessonDetails.startTime)
        let endTime = try? vm.convertDateStringToHoursAndMinutes(from: lessonDetails.endTime)

        let timeAndRoomText = "\(startTime ?? "") - \(endTime ?? "") · Кабинет: \(lessonDetails.room.name)"
        timeAndRoomLabel.text = timeAndRoomText
        let classInfoText = "\(lessonDetails.grade.name) класс · Учеников: \(lessonDetails.studentsCount)"
        classInfoLabel.text = classInfoText

        let deadline = lessonDetails.homework?.deadline ?? ""
        guard let deadlineString = try? vm.convertDateStringToDay(from: deadline) else { return }
        homeworkPanel.deadlineText = "Срок сдачи: \(deadlineString)"
    }

    private func getLessonDetails() {
        Task {
            do {
                try await vm.getLessonDetails()
                updateUI()
            } catch { print(error) }
        }
    }

    @objc func onTapHomework() {
        let setHomeworkVC = SetHomeworkViewController()
        self.navigationController?.pushViewController(setHomeworkVC, animated: true)
    }

    @objc func onTapStudentListButton() {
        let studentListVC = GradeStudentsListViewController(viewModel: self.vm)
        guard let lessonDetails = vm.lessonDetails else { return }
        studentListVC.titleText = "Ученики \(lessonDetails.grade.name) класса"
        studentListVC.subtitleText = "Учеников: \(lessonDetails.studentsCount)"
        self.navigationController?.pushViewController(studentListVC, animated: true)
    }

}
