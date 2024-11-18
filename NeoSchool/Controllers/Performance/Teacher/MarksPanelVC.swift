import SnapKit
import UIKit

class MarksPanelVC: UIViewController {
    private let performanceAPI: PerformanceAPIProtocol

    private var subjects: [SubjectName] = []
    private var selectedSubject: SubjectName?
    private var selectedGradeId: Int?
    private var selectedDate = Date()
    private var studentsMarks: [FullNameUser] = []

    private let scrollView = UIScrollView()
    private let containerView = ContainerView()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.maximumDate = Date()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()

    private let titleLabel = GrayUILabel(font: AppFont.font(type: .medium, size: 24))
    private let quaterLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .regular, size: 16)
        label.textColor = .neobisLightGray
        return label
    }()

    private let studentMarksListVC: StudentMarksListVC

    init(performanceAPI: PerformanceAPIProtocol) {
        self.performanceAPI = performanceAPI
        self.studentMarksListVC = StudentMarksListVC(performanceAPI: performanceAPI)

        super.init(nibName: nil, bundle: nil)
        studentMarksListVC.getGradeDayData = self.getGradeDayData
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.left.top.bottom.width.equalToSuperview() }

        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        containerView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(16)
        }
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(datePicker.snp.left)
        }
        containerView.addSubview(quaterLabel)
        quaterLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }
        addChild(studentMarksListVC)
        studentMarksListVC.didMove(toParent: self)
        containerView.addSubview(studentMarksListVC.view)
        studentMarksListVC.view.snp.makeConstraints { make in
            make.top.equalTo(quaterLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.height.greaterThanOrEqualTo(0)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (changeSubject))
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(tapGesture)
    }

    private func getGradeDayData() {
        guard let selectedGradeId, let selectedSubject else { return }
        Task {
            do {
                self.studentsMarks = try await performanceAPI.getGradeDayData(
                    gradeId: selectedGradeId,
                    subjectId: selectedSubject.id,
                    date: self.selectedDate
                )
                DispatchQueue.main.async {
                    self.updateUI()
                }
            } catch { print(error) }
        }
    }

    private func updateUI() {
        self.titleLabel.text = subjects.first(where: { $0 == selectedSubject })?.name
        let (quaterText, isVacation) = getQuarter(for: selectedDate)
        self.quaterLabel.text = quaterText
        self.datePicker.date = selectedDate
        self.studentMarksListVC.studentsMarks = isVacation ? [] : self.studentsMarks
        self.studentMarksListVC.selectedDate = selectedDate
        self.studentMarksListVC.selectedSubjectId = selectedSubject?.id
        self.studentMarksListVC.updateUI()
    }

    private func getQuarter(for date: Date) -> (String, Bool) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)

        guard let month = components.month, let day = components.day else {
            return ("Неизвестная дата", true)
        }

        switch (month, day) {
        case (9, 1...30), (10, 1...15):
            return ("I четверть", false)
        case (11, 1...30), (12, 1...25):
            return ("II четверть", false)
        case (1, 10...31), (2, 1...29), (3, 1...20):
            return ("III четверть", false)
        case (4, 1...30), (5, 1...25):
            return ("IV четверть", false)
        default:
            return ("Каникулы", true)
        }
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        self.selectedDate = sender.date
        self.getGradeDayData()
    }

    @objc func changeSubject() {
        guard let selectedSubject else { return }
        let selectedSubjInd = self.subjects.firstIndex(of: selectedSubject) ?? 0
        let nextInd = selectedSubjInd + 1 >= self.subjects.count ? 0 : selectedSubjInd + 1
        self.selectedSubject = self.subjects[nextInd]
        self.getGradeDayData()
    }
}

extension MarksPanelVC: GradesBarDelegate {
    func itemDidSelected(itemId: Int, subjects: [SubjectName]) {
        self.subjects = subjects
        self.selectedGradeId = itemId
        guard let firstSubject = subjects.first else { return }
        self.selectedSubject = firstSubject
        self.selectedDate = Date()
        self.getGradeDayData()
    }
}
