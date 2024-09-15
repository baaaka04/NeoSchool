import UIKit

class StudentLessonsListViewController: ItemsListViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let vm: TeacherDetailsViewModel
    private let studentId: Int
    var gradeName: String? {
        didSet {
            guard let gradeName else { return }
            subtitleText = gradeName + " класс"
        }
    }

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
        vm.submissions = []

        getStudentLessons()
    }

    private func getStudentLessons() {
        if !isLoading {
            Task {
                isLoading = true
                do {
                    self.totalPages = try await vm.getStudentLessons(studentId: self.studentId, currentPage: self.currentPage)
                    self.itemsList = vm.submissions
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
        let submission = itemsList[indexPath.item]
        guard let cell = self.teacherListCollectionView.dequeueReusableCell(withReuseIdentifier: TeacherItemListCollectionViewCell.identifier, for: indexPath) as? TeacherItemListCollectionViewCell
        else { return TeacherItemListCollectionViewCell(frame: .zero) }
        cell.title = submission.title
        cell.subtitle = submission.subtitle
        cell.datetimeText = submission.datetime
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let submission = self.itemsList[indexPath.item]
        let submissionDetailsVC = StudentHomeworkDetailsViewController(submissionId: submission.id, editable: false, vm: self.vm)
        submissionDetailsVC.titleText = submission.title
        submissionDetailsVC.subtitleText = "\(self.gradeName ?? "NuN") класс"
        self.navigationController?.pushViewController(submissionDetailsVC, animated: true)
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
                self.totalPages = try await vm.getStudentLessons(studentId: self.studentId, currentPage: currentPage)
                self.itemsList = vm.submissions
                updateUI()
                isLoading = false
            }
        }
    }


}
