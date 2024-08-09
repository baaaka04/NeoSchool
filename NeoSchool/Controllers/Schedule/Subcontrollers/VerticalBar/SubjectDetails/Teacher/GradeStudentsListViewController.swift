import UIKit
import SnapKit

class GradeStudentsListViewController: ItemsListViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let subjectId: Int
    let gradeId: Int
    let teacherAPI: TeacherLessonDayProtocol

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
        
        teacherListCollectionView.delegate = self
        teacherListCollectionView.dataSource = self
        emptyListView.title = "Учеников еще нет"

        getStudentList()
    }
    
    private func getStudentList() {
        Task {
            self.itemsList = try? await teacherAPI.getStudentList(subjectId: self.subjectId, gradeId: self.gradeId, page: 1)
            updateUI()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemsList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.teacherListCollectionView.dequeueReusableCell(withReuseIdentifier: TeacherItemListCollectionViewCell.identifier, for: indexPath) as? TeacherItemListCollectionViewCell,
              let student = itemsList?[indexPath.item]
        else { return TeacherItemListCollectionViewCell(frame: .zero) }
        cell.title = student.title
        cell.subtitle = student.subtitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let student = self.itemsList?[indexPath.item] else { return }
        let studentLessonsVC = StudentLessonsListViewController(studentId: 123, gradeId: 123, teacherAPI: self.teacherAPI)
        studentLessonsVC.titleText = student.title
        studentLessonsVC.subtitleText = self.titleText
        self.navigationController?.pushViewController(studentLessonsVC, animated: true)
    }

    
}
