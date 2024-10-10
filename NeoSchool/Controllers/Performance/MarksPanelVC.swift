import UIKit
import SnapKit

class MarksPanelVC: UIViewController {

    private let performanceAPI: PerformanceAPIProtocol

    private var subjects: [SubjectName] = []
    private var selectedSubject: SubjectName?
    private var selectedGradeId: Int?
    private var selectedDate: Date = Date()
    private var studentsMarks: [FullNameUser] = []

    private let scrollView = UIScrollView()
    private let containerView = ContainerView()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()

    private let titleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 24))
    private let quaterLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Regular, size: 16)
        label.textColor = .neobisLightGray
        return label
    }()

    private lazy var studentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StudentNameAndMarkCell.self, forCellWithReuseIdentifier: StudentNameAndMarkCell.identifier)
        return collectionView
    }()

    init(performanceAPI: PerformanceAPIProtocol) {
        self.performanceAPI = performanceAPI

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
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
        containerView.addSubview(studentsCollectionView)
        studentsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(quaterLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(12)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (changeSubject))
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(tapGesture)

    }

    private func getGradeDayData() {
        guard let selectedGradeId, let selectedSubject else { return }
        Task {
            self.studentsMarks = try await performanceAPI.getGradeDayData(
                gradeId: selectedGradeId,
                subjectId: selectedSubject.id,
                date: self.selectedDate
            )
            DispatchQueue.main.async {
                self.updateUI()
                self.studentsCollectionView.reloadData()
            }
        }
    }

    private func updateUI() {
        self.titleLabel.text = subjects.first(where: { $0 == selectedSubject })?.name
        self.quaterLabel.text = getQuarter(for: selectedDate)
        self.studentsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(self.studentsMarks.count*(53+6+5))
        }
    }

    private func getQuarter(for date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)

        guard let month = components.month, let day = components.day else {
            return "Неизвестная дата"
        }

        switch (month, day) {
        case (9, 1...30), (10, 1...15):
            return "I четверть"
        case (11, 1...30), (12, 1...25):
            return "II четверть"
        case (1, 10...31), (2, 1...29), (3, 1...20):
            return "III четверть"
        case (4, 1...30), (5, 1...25):
            return "IV четверть"
        default:
            return "Не в учебный период"
        }
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        self.selectedDate = sender.date
        self.quaterLabel.text = getQuarter(for: sender.date)
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

extension MarksPanelVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.studentsMarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentNameAndMarkCell.identifier, for: indexPath) as? StudentNameAndMarkCell else { return UICollectionViewCell() }
        cell.name = self.studentsMarks[indexPath.row].firstName
        cell.lastName = self.studentsMarks[indexPath.row].lastName
        if let mark = self.studentsMarks[indexPath.row].mark {
            cell.grade = Grade(rawValue: mark)
            cell.updateUI()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.studentsCollectionView.frame.width, height: 53)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //open modal window
    }

}
