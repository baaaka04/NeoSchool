import UIKit
import SnapKit

class SubjectLastMarksCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    static let identifier: String = "SubjectLastMarksCell"

    var titleText: String? {
        didSet {
            self.titleLabel.text = titleText
        }
    }

    var isYearGrades: Bool? {
        didSet {
            quaterGradeView.subtitleText = (self.isYearGrades ?? false) ? "Оцнека за год" : "Оцнека"
        }
    }

    var lastMarks: [Grade]?
    var quaterMark: Grade? {
        didSet {
            if let quaterMark {
                quaterGradeView.setGrade(grade: quaterMark, isRounded: true)
            }
        }
    }

    private let titleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 20))
    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let quaterGradeView = GradeView()

    private lazy var lastMarksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(LastMarksCell.self, forCellWithReuseIdentifier: LastMarksCell.identifier)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        contentView.addSubview(quaterGradeView)
        quaterGradeView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(48)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.right.equalTo(quaterGradeView.snp.left).offset(-12)
        }

        subtitleLabel.text = "Последние оценки"
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalTo(quaterGradeView.snp.left).offset(-12)
        }

        contentView.addSubview(lastMarksCollectionView)
        lastMarksCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
            make.height.equalTo(32)
            make.width.equalTo(192)
            make.bottom.equalToSuperview()
        }
    }

    func updateUI() {
        lastMarksCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lastMarks?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = lastMarksCollectionView.dequeueReusableCell(withReuseIdentifier: LastMarksCell.identifier, for: indexPath) as? LastMarksCell else { return UICollectionViewCell() }

        cell.grade = lastMarks?[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let squareSize = lastMarksCollectionView.frame.size.height
        return CGSize(width: squareSize, height: squareSize)
    }

}
