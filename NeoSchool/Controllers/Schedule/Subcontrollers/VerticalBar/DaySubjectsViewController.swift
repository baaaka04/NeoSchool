import UIKit
import SnapKit

class DaySubjectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    let dayScheduleAPI = DayScheduleAPI()
    var dayLessonsData : [StudentLesson]?
    
        
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
        
    lazy var subjectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 24
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 16
        collectionView.register(SubjectCollectionViewCell.self, forCellWithReuseIdentifier: SubjectCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(subjectCollectionView)

        subjectCollectionView.snp.makeConstraints { make in
            make.centerX.centerY.height.width.equalToSuperview()
        }
        
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
        let newHeight = SubjectCollectionViewCell.getProductHeightForWidth(
            title: lessonsDay.subject.name,
            font: AppFont.font(type: .Medium, size: 20),
            minHeight: Constants.subjectCellMinHeight,
            width: cellWidth - Constants.gradeViewWidth - Constants.gradeLeftMargin
        )
        return CGSize(width: cellWidth, height: newHeight)
    }
    
    // TAP ON A LESSON IN THE SCHEDULE LIST
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let subject = dayLessonsData?[indexPath.item] else { return }
        
        let viewModel = SubjectDetailsViewModel(lessonId: subject.id, lessonAPI: self.dayScheduleAPI)
        let subjectDetailsVC = SubjectDetailsViewController(viewModel: viewModel)

        self.navigationController?.pushViewController(subjectDetailsVC, animated: true)
    }
            
    @objc private func didTapBackButton () {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension DaySubjectsViewController: WorkdayScheduleViewDelegate {
    
    func dayDidSelected(day: Int) {
        getLessonData(forDayID: day)
    }

}
