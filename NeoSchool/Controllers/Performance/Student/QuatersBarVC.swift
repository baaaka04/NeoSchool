import UIKit
import SnapKit

protocol QuaterBarDelegate: AnyObject {
    func quaterDidSelect(quater: Quater)
}

class QuatersBarVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var delegate: QuaterBarDelegate?
    private let quaters: [Quater] = Quater.allCases
    private lazy var quatersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(WeekdayCollectionViewCell.self, forCellWithReuseIdentifier: WeekdayCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(quatersCollectionView)

        quatersCollectionView.snp.makeConstraints { make in
            make.centerX.centerY.width.height.equalToSuperview()
        }

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        quaters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = quatersCollectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCollectionViewCell.identifier, for: indexPath) as? WeekdayCollectionViewCell
        else { return UICollectionViewCell() }

        let quater = quaters[indexPath.row]
        cell.title = quater.romanNum
        cell.subtitle = quater.subtitle
        cell.selectedColor = .neobisPurple
        if indexPath.item == 0 && !cell.isSelected {
            self.quatersCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            delegate?.quaterDidSelect(quater: quater)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: quatersCollectionView.frame.size.width/5, height: quatersCollectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.quaterDidSelect(quater: quaters[indexPath.row])
    }


}
