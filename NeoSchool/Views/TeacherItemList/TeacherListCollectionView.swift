import UIKit

class TeacherListCollectionView: UICollectionView {
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        super.init(frame: .zero, collectionViewLayout: layout)

        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.register(
            TeacherItemListCollectionViewCell.self,
            forCellWithReuseIdentifier: TeacherItemListCollectionViewCell.identifier
        )
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
