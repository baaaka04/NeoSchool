import UIKit
import SnapKit


class QuaterMarkListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CommentRepresentableProtocol, CellDelegate {

    private let performanceAPI: PerformanceAPIProtocol

    private var subjects: [SubjectName] = []
    private var selectedSubject: SubjectName?
    private var selectedGradeId: Int?
    private var studentsMarks: [FullNameUser] = []

    private let subjectNameLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 24))
    private let headerView = QuaterTableHeaderView()
    private lazy var quaterMarksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QuaterMarkListCell.self, forCellWithReuseIdentifier: QuaterMarkListCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getGradeYearData()
    }

    init(performanceAPI: PerformanceAPIProtocol) {
        self.performanceAPI = performanceAPI

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        view.addSubview(subjectNameLabel)
        subjectNameLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (changeSubject))
        subjectNameLabel.isUserInteractionEnabled = true
        subjectNameLabel.addGestureRecognizer(tapGesture)

        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(subjectNameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        view.addSubview(quaterMarksCollectionView)
        quaterMarksCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.left.right.equalTo(headerView)
            make.bottom.equalToSuperview()
        }
    }

    private func updateUI() {
        quaterMarksCollectionView.reloadData()
        self.subjectNameLabel.text = selectedSubject?.name
    }

    private func getGradeYearData() {
        Task {
            guard let selectedGradeId, let selectedSubject else { return }
            self.studentsMarks = try await performanceAPI.getGradeQuaterData(gradeId: selectedGradeId, subjectId: selectedSubject.id)
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }

    @objc func changeSubject() {
        guard let selectedSubject else { return }
        let selectedSubjInd = self.subjects.firstIndex(of: selectedSubject) ?? 0
        let nextInd = selectedSubjInd + 1 >= self.subjects.count ? 0 : selectedSubjInd + 1
        self.selectedSubject = self.subjects[nextInd]
        self.getGradeYearData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        studentsMarks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuaterMarkListCell.identifier, for: indexPath) as? QuaterMarkListCell else {
            return UICollectionViewCell()
        }
        let studentMarks = self.studentsMarks[indexPath.row]

        var quaterMarks: [QuaterMark] = []
        for quater in QuaterName.allCases {
            let finalMark = studentMarks.quarterMarks?.first(where: { $0.quarter == quater })
            let quaterMark = QuaterMark(
                id: finalMark?.id ?? 1,
                student: studentMarks.id,
                subject: selectedSubject?.id ?? 1,
                quarter: quater,
                finalMark: finalMark?.finalMark ?? .noGrade
            )
            quaterMarks.append(quaterMark)
        }
        cell.quaterMarks = quaterMarks
        cell.name = studentMarks.firstName + " " + studentMarks.lastName
        if let avgMark = studentMarks.avgMark {
            cell.avarageMark = "Средний балл: " + avgMark
        }
        cell.delegate = self
        cell.updateUI()
        return cell
    }

    // CommentRepresentableProtocol and CellDelegate protocols
    var userComment: String? = nil
    var grade: Grade?
    var selectedQuater: QuaterName?
    var selectedStudentId: Int?

    func presentVC(quater: QuaterName, studentId: Int, studentName: String, avarageMark: String?) {
        self.selectedQuater = quater
        self.selectedStudentId = studentId
        openCommentView(studentName: studentName, avarageMark: avarageMark)
    }

    func openCommentView(studentName: String, avarageMark: String?) {
        guard let selectedQuater else { return }
        let commentInfo = CommentInfo(selectedStudentName: studentName, selectedQuater: selectedQuater, avarageMark: avarageMark)
        let commentVC = CommentModalViewController(type: .teacherQuaterWithoutComment, commentInfo: commentInfo)
        commentVC.delegate = self
        commentVC.getLessonDetails = { [weak self] in
            self?.getGradeYearData()
        }
        commentVC.modalPresentationStyle = .overFullScreen
        self.present(commentVC, animated: false)
    }

    func submit(_ submissionId: Int?) async throws {
        Task {
            guard let grade, let selectedStudentId, let selectedSubject, let selectedQuater else { return }
            try await performanceAPI.setGradeForQuater(grade: grade, studentId: selectedStudentId, subjectId: selectedSubject.id, quater: selectedQuater)
        }
    }
}

extension QuaterMarkListViewController: GradesBarDelegate {
    func itemDidSelected(itemId: Int, subjects: [SubjectName]) {
        self.subjects = subjects
        self.selectedGradeId = itemId
        guard let firstSubject = subjects.first else { return }
        self.selectedSubject = firstSubject
        self.getGradeYearData()
    }
}

