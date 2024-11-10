import UIKit
import SnapKit

class DaySubjectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    private let userRole: UserRole
    private let dayScheduleAPI = DayScheduleAPI()
    private var dayLessonsData : [SchoolLesson]?
    private var collectionHeight: CGFloat = 24
    
    private let scrollview = UIScrollView()
        
    private lazy var subjectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 24
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 16
        collectionView.layer.shadowColor = UIColor.neobisShadow.cgColor
        collectionView.layer.shadowOpacity = 0.1
        collectionView.layer.shadowOffset = .zero
        collectionView.layer.shadowRadius = 10
        collectionView.layer.masksToBounds = false
        switch userRole {
        case .teacher: collectionView.register(TeacherLessonCollectionViewCell.self, forCellWithReuseIdentifier: TeacherLessonCollectionViewCell.identifier)
        case .student: collectionView.register(StudentLessonCollectionViewCell.self, forCellWithReuseIdentifier: StudentLessonCollectionViewCell.identifier)
        }
        return collectionView
    }()
    
    init(userRole: UserRole) {
        self.userRole = userRole
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getLessonData(forDayID: 1)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dayLessonsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String
        switch userRole {
        case .teacher: cellIdentifier = TeacherLessonCollectionViewCell.identifier
        case .student: cellIdentifier = StudentLessonCollectionViewCell.identifier
        }

        guard let lessonsDay = dayLessonsData?[indexPath.item] else { return UICollectionViewCell(frame: .zero) }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as UICollectionViewCell
        configureCell(cell, with: lessonsDay, for: userRole, at: indexPath)
        return cell
    }

    func configureCell(_ cell: UICollectionViewCell, with lessonsDay: SchoolLesson, for role: UserRole, at indexPath: IndexPath) {
        let subtitle = "\(lessonsDay.startTime) – \(lessonsDay.endTime) · Кабинет: \(lessonsDay.room.name)"
        
        switch role {
        case .teacher:
            if let cell = cell as? TeacherLessonCollectionViewCell {
                cell.title = "\(indexPath.item + 1). \(lessonsDay.grade?.name ?? "") класс"
                cell.subtitle = subtitle
                cell.subjectName = lessonsDay.subject.name
                cell.homeworkCount = lessonsDay.homeworkCount
            }
            
        case .student:
            if let cell = cell as? StudentLessonCollectionViewCell {
                cell.title = "\(indexPath.item + 1). \(lessonsDay.subject.name)"
                cell.subtitle = subtitle
                cell.descr = "Задано: \(lessonsDay.homework?.text ?? "-")"
                cell.setGrade(to: Grade(rawValue: lessonsDay.mark ?? "-") ?? .noGrade)
            }
        }
    }
        
    struct Constants {
        static let subjectCellHorizontalMargin: CGFloat = 16
        static let gradeLeftMargin : CGFloat = 16
        static let gradeViewWidth : CGFloat = 48
        static let subjectCellMinHeight : CGFloat = 51
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let lessonsDay = dayLessonsData?[indexPath.item] else { return .zero }
        let cellWidth = view.frame.size.width - Constants.subjectCellHorizontalMargin * 2
        let cellHeight = LessonCollectionViewCell.getCellHeightForWidth(
            title: lessonsDay.subject.name,
            font: AppFont.font(type: .Medium, size: 20),
            minHeight: Constants.subjectCellMinHeight,
            width: cellWidth - Constants.gradeViewWidth - Constants.gradeLeftMargin
        )
        self.collectionHeight += (cellHeight + 24)
        subjectCollectionView.snp.updateConstraints { $0.height.equalTo(self.collectionHeight) }
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // TAP ON A LESSON IN THE SCHEDULE LIST
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let lesson = dayLessonsData?[indexPath.item] else { return }

        switch userRole {
        case .teacher:
            let viewModel = TeacherDetailsViewModel(lessonId: lesson.id, teacherAPI: self.dayScheduleAPI)
            let teacherLessonDetailsVC = TeacherLessonDetailVC(viewModel: viewModel)
            self.navigationController?.pushViewController(teacherLessonDetailsVC, animated: true)
        case .student:
            let viewModel = SubjectDetailsViewModel(lessonId: lesson.id, lessonAPI: self.dayScheduleAPI)
            let studentLessonDetailsVC = SubjectDetailsStatefulViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(studentLessonDetailsVC, animated: true)
        }
    }
    
    private func getLessonData(forDayID day: Int) {
        Task {
            do {
                dayLessonsData = try await dayScheduleAPI.getLessons(forDayId: day, userRole: self.userRole)
            } catch {
                print(error)
            }
            subjectCollectionView.reloadData()
        }
    }
    
    private func setupUI() {
        scrollview.showsVerticalScrollIndicator = false
        view.addSubview(scrollview)
        scrollview.snp.makeConstraints { $0.top.left.bottom.width.equalToSuperview() }

        scrollview.addSubview(subjectCollectionView)
        subjectCollectionView.snp.makeConstraints { make in
            make.top.bottom.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
    }

            
    @objc private func didTapBackButton () {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension DaySubjectsViewController: ItemsBarDelegate {
    
    func didSelectItem(itemId: Int) {
        self.collectionHeight = 24
        getLessonData(forDayID: itemId)
    }

}
