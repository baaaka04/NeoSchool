import UIKit
import SnapKit

class SubmissionsListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var items: [TeacherClassItem] = []
    var gradeName: String?
    private var vm: StudentHomeworkProtocol?

    private let noHomeworkView = NotepadView(title: "Пока нет заданий", subtitle: "Ученики пока не присылали работы по данному заданию")
    private lazy var submissionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TeacherItemListCollectionViewCell.self, forCellWithReuseIdentifier: TeacherItemListCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false

        return collectionView
    }()

    init(vm: StudentHomeworkProtocol? = nil) {
        self.vm = vm
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
        view.addSubview(submissionsCollectionView)
        view.addSubview(noHomeworkView)
        submissionsCollectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        noHomeworkView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func updateUI() {
        submissionsCollectionView.reloadData()

        submissionsCollectionView.isHidden = self.items.isEmpty
        noHomeworkView.isHidden = !self.items.isEmpty
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let submission = items[indexPath.item]
        guard let cell = self.submissionsCollectionView.dequeueReusableCell(withReuseIdentifier: TeacherItemListCollectionViewCell.identifier, for: indexPath) as? TeacherItemListCollectionViewCell
        else { return TeacherItemListCollectionViewCell(frame: .zero) }
        cell.title = submission.title

        var submittedOnTimeString : NSAttributedString {
            let attributedString = NSMutableAttributedString(string: submission.subtitle)
            guard let onTime = submission.onTime else { return attributedString }
            let headColor: UIColor = onTime ? .neobisGreen : .neobisRed
            attributedString.addAttribute(
                .foregroundColor, 
                value: headColor,
                range: NSRange(location: 0, length: attributedString.length-12) //12 is the length of " · Оценка: -"
            )
            return  attributedString
        }

        cell.attributedSubtitle = submittedOnTimeString
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let submission = self.items[indexPath.item]
        let submissionDetailsVC = StudentHomeworkDetailsViewController(submissionId: submission.id, editable: true, vm: self.vm)
        submissionDetailsVC.titleText = submission.title
        submissionDetailsVC.subtitleText = "\(self.gradeName ?? "NuN") класс"
        self.navigationController?.pushViewController(submissionDetailsVC, animated: true)
    }


}
