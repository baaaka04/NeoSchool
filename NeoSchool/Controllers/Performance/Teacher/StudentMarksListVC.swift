import UIKit
import SnapKit

class StudentMarksListVC: UIViewController, CommentRepresentableProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let performanceAPI: PerformanceAPIProtocol

    var userComment: String? = nil
    var grade: Grade?
    var selectedSubjectId: Int?
    var selectedDate: Date?
    var studentsMarks: [FullNameUser] = []
    private var selectedStudentId: Int?
    var getGradeDayData: (() -> Void)?

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
    private let vacationView = NotepadView(title: "Идут каникулы", subtitle: "Вы выбрали дату, выпадающую на каникулы, поэтому поставить ученикам оценки невозможно. Выберите другую дату")

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
        view.addSubview(studentsCollectionView)
        view.addSubview(vacationView)
        studentsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        vacationView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
    }

    func updateUI() {
        studentsCollectionView.reloadData()

        studentsCollectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(self.studentsMarks.count*(53+6+5))
        }

        studentsCollectionView.isHidden = self.studentsMarks.isEmpty
        vacationView.isHidden = !self.studentsMarks.isEmpty
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.studentsMarks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentNameAndMarkCell.identifier, for: indexPath) as? StudentNameAndMarkCell else { return UICollectionViewCell() }
        let student = self.studentsMarks[indexPath.row]
        cell.name = student.firstName
        cell.lastName = student.lastName
        if let mark = student.mark {
            cell.selectedGrade = Grade(rawValue: mark)
        } else {
            cell.selectedGrade = nil
        }
        cell.updateUI()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.studentsCollectionView.frame.width, height: 53)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedStudentId = self.studentsMarks[indexPath.row].id
        openCommentView()
    }

    func openCommentView() {
        let commentVC = CommentModalViewController(type: .teacherWithoutComment)
        commentVC.delegate = self
        commentVC.getLessonDetails = { [weak self] in
            self?.getGradeDayData?()
        }
        commentVC.modalPresentationStyle = .overFullScreen
        self.present(commentVC, animated: false)
    }

    func submit(_ submissionId: Int?) async throws {
        Task {
            guard let grade, let selectedStudentId, let selectedSubjectId, let selectedDate else {
                throw MyError.noDataReceived
            }
            try await performanceAPI.setGradeForLesson (
                grade: grade,
                studentId: selectedStudentId,
                subjectId: selectedSubjectId,
                date: selectedDate
            )
        }
    }

}
