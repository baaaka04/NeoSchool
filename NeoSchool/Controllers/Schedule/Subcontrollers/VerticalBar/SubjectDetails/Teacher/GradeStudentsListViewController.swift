import UIKit
import SnapKit

class GradeStudentsListViewController: ItemsListViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let vm: TeacherDetailsViewModel

    init( viewModel: TeacherDetailsViewModel) {
        self.vm = viewModel
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
            do {
                try await vm.getStudentList()
                self.itemsList = vm.students
                updateUI()
            } catch { print(error) }
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
        guard let student: TeacherClassItem = self.itemsList?[indexPath.item],
        let lessonDetails = vm.lessonDetails else { return }
        let studentLessonsVC = StudentLessonsListViewController(viewModel: self.vm, studentId: student.id)
        studentLessonsVC.titleText = student.title
        studentLessonsVC.subtitleText = lessonDetails.grade.name + " класс"
        self.navigationController?.pushViewController(studentLessonsVC, animated: true)
    }

    
}
