import UIKit

class StudentLessonsListViewController: ItemsListViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let vm: TeacherDetailsViewModel
    private let studentId: Int

    init(viewModel: TeacherDetailsViewModel, studentId: Int) {
        self.studentId = studentId
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
        emptyListView.title = "Уроков еще нет"

        getStudentLessons()
    }

    private func getStudentLessons() {
        Task {
            do {
                try await vm.getStudentLessons(studentId: self.studentId)
                self.itemsList = vm.submissions
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
        cell.datetimeText = student.datetime
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }


}
