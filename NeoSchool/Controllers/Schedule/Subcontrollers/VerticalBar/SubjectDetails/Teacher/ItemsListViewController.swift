import UIKit
import SnapKit

class ItemsListViewController: DetailViewController {

    var titleText: String? {
        didSet { titleLabel.text = titleText }
    }

    var subtitleText: String? {
        didSet { subtitleLabel.text = subtitleText }
    }
    var itemsList : [TeacherClassItem]?

    private let titleLabel = GrayUILabel(font: AppFont.font(type: .SemiBold, size: 28))
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

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emptyListView)
        view.addSubview(teacherListCollectionView)

        setupUI()
    }

    private func setupUI() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(16)
        }
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
        emptyListView.isHidden = self.itemsList != nil
        teacherListCollectionView.isHidden = self.itemsList == nil
    }

}
