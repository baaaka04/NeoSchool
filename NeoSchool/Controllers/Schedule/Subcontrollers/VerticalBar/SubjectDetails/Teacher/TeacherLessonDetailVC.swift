import UIKit
import SnapKit

class TeacherLessonDetailVC: DetailViewController {
    
    private let lessonAPI : TeacherLessonDayProtocol
    private let lessonId: Int
    private var lessonDetails: TeacherLessonDetail?
    
    private let titleLabel = GrayUILabel(font: AppFont.font(type: .SemiBold, size: 28))
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
    
    init(lessonId: Int, lessonAPI: TeacherLessonDayProtocol = DayScheduleAPI()) {
        self.lessonId = lessonId
        self.lessonAPI = lessonAPI
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
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
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(100)
        }
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
    
    private func updateData() {
        guard let lessonDetails else { return }
        titleLabel.text = lessonDetails.subject.name

        let startTime = try? convertDataStringToHoursAndMinutes(from: lessonDetails.startTime)
        let endTime = try? convertDataStringToHoursAndMinutes(from: lessonDetails.endTime)

        let timeAndRoomText = "\(startTime ?? "") - \(endTime ?? "") · Кабинет: \(lessonDetails.room.name)"
        timeAndRoomLabel.text = timeAndRoomText
        let classInfoText = "\(lessonDetails.grade.name) класс · Учеников: \(lessonDetails.studentCount)"
        classInfoLabel.text = classInfoText

        let deadline = lessonDetails.homework.deadline
        guard let deadlineString = try? convertDataStringToDay(from: deadline) else { return }
        homeworkPanel.deadlineText = "Срок сдачи: \(deadlineString)"
    }

    private func getDateFromString(dateString: String) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        guard let date = dateFormatter.date(from: dateString) else { throw MyError.invalidDateFormat }
        return date
    }

    private func getTimeFromDate(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: date)

        return timeString
    }

    private func getDayFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    private func convertDataStringToHoursAndMinutes(from dateString: String) throws -> String {
        let date = try getDateFromString(dateString: dateString)
        let timeString = getTimeFromDate(date: date)
        return timeString
    }

    private func convertDataStringToDay(from dateString: String) throws -> String {
        let date = try getDateFromString(dateString: dateString)
        let dayString = getDayFromDate(date: date)
        return dayString
    }

    private func getLessonDetails() {
        Task {
            do {
                let lessonDetailsData = try await lessonAPI.getTeacherLessonDetail(forLessonId: self.lessonId)
                DispatchQueue.main.async {
                    self.lessonDetails = lessonDetailsData
                    self.updateData()
                }
            } catch { print(error) }
        }
    }
    
    @objc func onTapHomework() {
        let setHomeworkVC = SetHomeworkViewController()
        self.navigationController?.pushViewController(setHomeworkVC, animated: true)
    }

    @objc func onTapStudentListButton() {
        let studentListVC = StudentsListViewController(subjectId: 1, gradeId: 1, teacherAPI: self.lessonAPI)
        studentListVC.titleText = "Ученики 5 А класса"
        studentListVC.studentsCountText = "Учеников: 0"
        self.navigationController?.pushViewController(studentListVC, animated: true)
    }

}
