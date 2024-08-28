import UIKit
import SnapKit

class ItemsListViewController: DetailTitledViewController {

    //MARK: Pagination
    var currentPage: Int = 1
    var totalPages: Int = 1
    var isLoading: Bool = false

    var subtitleText: String? {
        didSet { subtitleLabel.text = subtitleText }
    }
    var itemsList : [TeacherClassItem] = []

    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 16))

    let emptyListView = NotepadView()

    lazy var teacherListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TeacherItemListCollectionViewCell.self, forCellWithReuseIdentifier: TeacherItemListCollectionViewCell.identifier)

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(subtitleLabel)
        view.addSubview(emptyListView)
        view.addSubview(teacherListCollectionView)

        setupUI()
    }

    private func setupUI() {

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        emptyListView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        teacherListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func updateUI() {
        teacherListCollectionView.reloadData()
        emptyListView.isHidden = self.itemsList.count != 0
        teacherListCollectionView.isHidden = self.itemsList.count == 0
    }

}
