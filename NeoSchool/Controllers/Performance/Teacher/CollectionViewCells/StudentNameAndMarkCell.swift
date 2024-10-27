import UIKit
import SnapKit

class StudentNameAndMarkCell: AutosizeUICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    static let identifier: String = "StudentNameAndMarkCell"

    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }

    var lastName: String? {
        didSet {
            lastNameLabel.text = lastName
        }
    }

    private let nameLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))
    private let lastNameLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))

    var selectedGrade: Grade?
    private let grades: [Grade] = Grade.allCases.filter { $0 != .noGrade }

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

        [nameLabel, lastNameLabel, gradesCollectionView].forEach { contentView.addSubview($0) }
        [nameLabel, lastNameLabel].forEach { $0.numberOfLines = 1 }

        gradesCollectionView.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(40)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.right.equalTo(gradesCollectionView.snp.left)
        }
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(gradesCollectionView.snp.left)
        }
    }

    func updateUI() {
        self.gradesCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.grades.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallGradeCell.identifier, for: indexPath) as? SmallGradeCell else {
            return UICollectionViewCell()
        }
        let grade = grades[indexPath.row]
        cell.gradeName = grade.rawValue
        if self.selectedGrade == grade {
            cell.selectedBackgroundColor = self.selectedGrade?.color
        } else {
            cell.selectedBackgroundColor = .neobisGray
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (self.gradesCollectionView.frame.width-4*4)/6, height: self.gradesCollectionView.frame.height)
    }

}


