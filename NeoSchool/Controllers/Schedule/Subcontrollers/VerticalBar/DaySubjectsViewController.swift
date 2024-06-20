import UIKit
import SnapKit

class DaySubjectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    private let dayScheduleAPI = DayScheduleAPI()
    private var dayLessonsData : [StudentLesson]?
    private var collectionHeight: CGFloat = 24
    
    private let scrollview = UIScrollView()
        
    lazy var subjectCollectionView: UICollectionView = {
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
        collectionView.register(SubjectCollectionViewCell.self, forCellWithReuseIdentifier: SubjectCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollview)
        scrollview.addSubview(subjectCollectionView)

        setupUI()
        getLessonData(forDayID: 1)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dayLessonsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = subjectCollectionView.dequeueReusableCell(withReuseIdentifier: SubjectCollectionViewCell.identifier, for: indexPath) as? SubjectCollectionViewCell,
              let lessonsDay = dayLessonsData?[indexPath.item] else {
            return SubjectCollectionViewCell(frame: .zero)
        }
        cell.id = indexPath.item + 1
        cell.title = lessonsDay.subject.name
        cell.subtitle = "\(lessonsDay.startTime) - \(lessonsDay.endTime) · Кабинет: \(lessonsDay.room.name)"
        cell.descr = "Задано: \(lessonsDay.homework?.text ?? "-")"
        cell.setGrade(to: Grade(rawValue: lessonsDay.mark ?? "-") ?? .noGrade)
        return cell
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
        let cellHeight = SubjectCollectionViewCell.getProductHeightForWidth(
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
        guard let subject = dayLessonsData?[indexPath.item] else { return }
        
        let viewModel = SubjectDetailsViewModel(lessonId: subject.id, lessonAPI: self.dayScheduleAPI)
        let subjectDetailsVC = SubjectDetailsStatefulViewController(viewModel: viewModel)

        self.navigationController?.pushViewController(subjectDetailsVC, animated: true)
    }
    
    private func getLessonData(forDayID day: Int) {
        Task {
            do {
                dayLessonsData = try await dayScheduleAPI.getLessons(forDayId: day)
            } catch {
                print(error)
            }
            subjectCollectionView.reloadData()
        }
    }
    
    private func setupUI() {
                
        scrollview.snp.makeConstraints { $0.top.left.bottom.width.height.equalToSuperview() }

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

extension DaySubjectsViewController: WorkdayScheduleViewDelegate {
    
    func dayDidSelected(day: Int) {
        self.collectionHeight = 24
        getLessonData(forDayID: day)
    }

}
