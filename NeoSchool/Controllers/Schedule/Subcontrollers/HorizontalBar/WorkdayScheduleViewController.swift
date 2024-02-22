import UIKit
import SnapKit


class WorkdayScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var weekCollectionView: UICollectionView = {
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
    
    let indexOfSelectedDay: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(weekCollectionView)
        
        weekCollectionView.snp.makeConstraints { make in
            make.centerX.centerY.width.height.equalToSuperview()
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        studentWeek.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCollectionViewCell.identifier, for: indexPath) as? WeekdayCollectionViewCell else {
            return WeekdayCollectionViewCell(frame: .zero)
        }
        cell.id = studentWeek[indexPath.item].id
        cell.title = studentWeek[indexPath.item].name
        
        let lessonsCount = studentWeek[indexPath.item].lessonsCount
        let lessonsCountEnding = changeEnding(byCount: lessonsCount, threeCases: ["урок", "урока", "уроков"])
        let lessonsCountSubtitle = "\(lessonsCount) \(lessonsCountEnding)"
        cell.subtitle = lessonsCountSubtitle
        
        if indexPath.item == 0 && !cell.isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            cell.isSelected = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: weekCollectionView.frame.size.width/6, height: weekCollectionView.frame.size.height)
    }
        
    private func changeEnding(byCount: Int, threeCases: [String]) -> String {
        guard !(threeCases.count < 3) else { return "" }
        var result = ""
        let lastChar = String(byCount).suffix(1)
        let interger = Int(lastChar) ?? 1
        switch interger {
        case 1:
            result = threeCases[0]
        case 2...4:
            result = threeCases[1]
        case 4...:
            result = threeCases[2]
        default:
            fatalError()
        }
        return result
    }
}
