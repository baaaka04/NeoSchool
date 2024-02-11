import UIKit
import SnapKit

struct StudentDay {
    let id: Int
    let name: String
    let lessonsCount: String
}

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
    
    let studentWeek: [StudentDay] = [
        .init(id: 0, name: "ПН", lessonsCount: "5 уроков"),
        .init(id: 1, name: "ВТ", lessonsCount: "6 уроков"),
        .init(id: 2, name: "СР", lessonsCount: "6 уроков"),
        .init(id: 3, name: "ЧТ", lessonsCount: "4 урока"),
        .init(id: 4, name: "ПТ", lessonsCount: "5 уроков"),
        .init(id: 5, name: "СБ", lessonsCount: "3 урока"),
    ]
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
        cell.subtitle = studentWeek[indexPath.item].lessonsCount
        cell.selectCell(cellID: indexOfSelectedDay)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: weekCollectionView.frame.size.width/6, height: weekCollectionView.frame.size.height)
    }
}
