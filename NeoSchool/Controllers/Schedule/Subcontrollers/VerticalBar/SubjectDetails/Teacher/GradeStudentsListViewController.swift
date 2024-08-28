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
        vm.students = []

        getStudentList()
    }
    
    private func getStudentList() {
        if !isLoading {
            Task {
                isLoading = true
                do {
                    self.totalPages = try await vm.getStudentList(currentPage: self.currentPage)
                    self.itemsList = vm.students
                    updateUI()
                } catch { print(error) }
                isLoading = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let student = itemsList[indexPath.item]
        guard let cell = self.teacherListCollectionView.dequeueReusableCell(withReuseIdentifier: TeacherItemListCollectionViewCell.identifier, for: indexPath) as? TeacherItemListCollectionViewCell
        else { return TeacherItemListCollectionViewCell(frame: .zero) }
        cell.title = student.title
        cell.subtitle = student.subtitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let student = self.itemsList[indexPath.item]
        guard let lessonDetails = vm.lessonDetails else { return }
        let studentLessonsVC = StudentLessonsListViewController(viewModel: self.vm, studentId: student.id)
        studentLessonsVC.titleText = student.title
        studentLessonsVC.subtitleText = lessonDetails.grade.name + " класс"
        self.navigationController?.pushViewController(studentLessonsVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleItems = teacherListCollectionView.indexPathsForVisibleItems
        guard let visibleItemsLastIndexPath = visibleItems.max() else { return }

        let totalItems = teacherListCollectionView.numberOfItems(inSection: 0)
        let triggerIndex = totalItems - 3 // Trigger when the third-to-last element is visible

        if visibleItemsLastIndexPath.item >= triggerIndex && !isLoading && currentPage < totalPages {
            currentPage += 1
            Task {
                isLoading = true
                self.totalPages = try await vm.getStudentList(currentPage: currentPage)
                self.itemsList = vm.students
                updateUI()
                isLoading = false
            }
        }
    }

}
