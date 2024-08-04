import UIKit
import SnapKit

class StudentsListViewController: DetailViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let subjectId: Int
    let gradeId: Int
    let teacherAPI: TeacherLessonDayProtocol

    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var studentsCountText: String? {
        didSet {
            studentsCountLabel.text = studentsCountText
        }
    }
    
    private let titleLabel = GrayUILabel(font: AppFont.font(type: .SemiBold, size: 28))
    private let studentsCountLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 16))
    
    private let noStudentListView = NotepadView(title: "Учеников еще нет")
    
    private var studentsList : [StudentSubmissionCount]?
    private lazy var studentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(StudentsListCollectionViewCell.self, forCellWithReuseIdentifier: StudentsListCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    init(subjectId: Int, gradeId: Int, teacherAPI: TeacherLessonDayProtocol) {
        self.subjectId = subjectId
        self.gradeId = gradeId
        self.teacherAPI = teacherAPI
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(studentsCountLabel)
        view.addSubview(noStudentListView)
        view.addSubview(studentsCollectionView)
        
        setupUI()
        getStudentList()
    }
    
    private func setupUI() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(16)
        }
        studentsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        noStudentListView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        studentsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(studentsCountLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateUI() {
        studentsCollectionView.reloadData()
        self.studentsCountLabel.text = "Учеников: \(self.studentsList?.count ?? 0)"
        noStudentListView.isHidden = self.studentsList != nil
        studentsCollectionView.isHidden = self.studentsList == nil
    }
    
    private func getStudentList() {
        Task {
            self.studentsList = try await teacherAPI.getStudentList(subjectId: self.subjectId, gradeId: self.gradeId, page: 1)
            updateUI()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        studentsList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = studentsCollectionView.dequeueReusableCell(withReuseIdentifier: StudentsListCollectionViewCell.identifier, for: indexPath) as? StudentsListCollectionViewCell,
              let student = studentsList?[indexPath.item]
        else { return StudentsListCollectionViewCell(frame: .zero) }
        cell.studentName = "\(student.firstName) \(student.lastName)"
        cell.homeworkCount = "Заданий сдано: \(student.submissionsCount)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }
    
    
}
