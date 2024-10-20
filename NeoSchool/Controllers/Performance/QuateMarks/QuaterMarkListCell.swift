import UIKit
import SnapKit

class QuaterMarkListCell: AutosizeUICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static let identifier: String = "QuaterMarkListCell"

    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }

    var avarageMark: String? {
        didSet {
            avarageMarkLabel.text = avarageMark
        }
    }
    var quaterMarks: [QuaterMark]?

    private let nameLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))
    private let avarageMarkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neobisLightGray
        label.font = AppFont.font(type: .Regular, size: 14)
        return label
    }()


    private lazy var gradesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SmallGradeCell.self, forCellWithReuseIdentifier: SmallGradeCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        let containerView = UIView()

        containerView.addSubview(nameLabel)
        containerView.addSubview(avarageMarkLabel)

        nameLabel.numberOfLines = 0
        avarageMarkLabel.numberOfLines = 0

        nameLabel.snp.makeConstraints { $0.left.top.right.equalToSuperview() }
        avarageMarkLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        contentView.addSubview(gradesCollectionView)
        gradesCollectionView.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.width.equalTo(183)
            make.height.equalTo(40)
        }

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.centerY.left.equalToSuperview()
            make.width.equalTo(165)
        }
    }

    func updateUI() {
        self.gradesCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.quaterMarks?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallGradeCell.identifier, for: indexPath) as? SmallGradeCell else {
            return UICollectionViewCell()
        }
        guard let grade = self.quaterMarks?[indexPath.row].finalMark else { return UICollectionViewCell() }
        cell.gradeName = grade.rawValue
        cell.selectedBackgroundColor = grade.color
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (self.gradesCollectionView.frame.width-4*4)/5, height: self.gradesCollectionView.frame.height)
    }
}


