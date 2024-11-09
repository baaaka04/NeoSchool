import UIKit
import SnapKit

class ClassworkListViewController: StudentworksListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getLastMarks()
    }

    private func getLastMarks() {
        Task {
            let classworkMarks = try await performanceAPI.getSubjectClassworkLastMarks(quater: quater.rawValue, subjectId: subjectId)
            self.items = classworkMarks.map { TeacherClassItem(classwork: $0) }

            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
}

class HomeworkListViewController: StudentworksListViewController {

    let lessonAPI = DayScheduleAPI()

    override func viewDidLoad() {
        super.viewDidLoad()

        getLastMarks()
    }

    private func getLastMarks() {
        Task {
            let homeworkMarks = try await performanceAPI.getSubjectHomeworkLastMarks(quater: quater.rawValue, subjectId: subjectId)
            self.items = homeworkMarks.map { TeacherClassItem(homework: $0) }

            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.items.isEmpty == false else { return }
        let lessonId = self.items[indexPath.row].id
        let vm = SubjectDetailsViewModel(lessonId: lessonId, lessonAPI: lessonAPI)
        let submissionDetailsVC = SubmittedSubjectDetailsViewController(viewModel: vm)
        self.navigationController?.pushViewController(submissionDetailsVC, animated: true)
        Task {
            try await vm.getLessonDetailData()
            submissionDetailsVC.updateUI()
        }
    }
}

class StudentworksListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let performanceAPI: PerformanceAPIProtocol
    private let teacherListCollectionView = TeacherListCollectionView()
    var items: [TeacherClassItem] = []
    let quater: Quater
    let subjectId: Int
    private let hasDetails: Bool

    private let emptyView = NotepadView(title: "Оценок пока нет", subtitle: "Когда учитель оценит вашу работу, здесь будут оценки")

    init(performanceAPI: PerformanceAPIProtocol, quater: Quater, subjectId: Int, hasDetails: Bool) {
        self.performanceAPI = performanceAPI
        self.quater = quater
        self.subjectId = subjectId
        self.hasDetails = hasDetails
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
        view.addSubview(teacherListCollectionView)
        teacherListCollectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { $0.centerX.centerY.width.equalToSuperview() }

        teacherListCollectionView.delegate = self
        teacherListCollectionView.dataSource = self
    }

    func updateUI() {
        self.emptyView.isHidden = !self.items.isEmpty
        self.teacherListCollectionView.isHidden = self.items.isEmpty
        self.teacherListCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let homework = items[indexPath.item]
        guard let cell = self.teacherListCollectionView.dequeueReusableCell(withReuseIdentifier: TeacherItemListCollectionViewCell.identifier, for: indexPath) as? TeacherItemListCollectionViewCell
        else { return TeacherItemListCollectionViewCell(frame: .zero) }
        cell.title = homework.title
        cell.subtitle = homework.subtitle
        cell.datetimeText = homework.datetime
        if !hasDetails { cell.removeArrow() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }

}
