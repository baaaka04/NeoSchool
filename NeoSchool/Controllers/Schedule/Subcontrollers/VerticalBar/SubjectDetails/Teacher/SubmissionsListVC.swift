import UIKit
import SnapKit

class SubmissionsListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var items: [TeacherClassItem] = []
    var gradeName: String?
    private var vm: StudentHomeworkProtocol?

    private lazy var submissionsCollectionView: UICollectionView = {
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
        collectionView.register(TeacherItemListCollectionViewCell.self, forCellWithReuseIdentifier: TeacherItemListCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.addSubview(submissionsCollectionView)
        submissionsCollectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func updateUI() {
        submissionsCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let submission = items[indexPath.item]
        guard let cell = self.submissionsCollectionView.dequeueReusableCell(withReuseIdentifier: TeacherItemListCollectionViewCell.identifier, for: indexPath) as? TeacherItemListCollectionViewCell
        else { return TeacherItemListCollectionViewCell(frame: .zero) }
        cell.title = submission.title
        cell.subtitle = submission.subtitle
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let submission = self.items[indexPath.item]
        let submissionDetailsVC = StudentHomeworkDetailsViewController(submissionId: submission.id, vm: self.vm)
        submissionDetailsVC.titleText = submission.title
        submissionDetailsVC.subtitleText = "\(self.gradeName ?? "NuN") класс"
        self.navigationController?.pushViewController(submissionDetailsVC, animated: true)
    }


}
