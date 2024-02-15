import UIKit
import SnapKit

class DaySubjectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var subjectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 24
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 16
        collectionView.register(SubjectCollectionViewCell.self, forCellWithReuseIdentifier: SubjectCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(subjectCollectionView)

        subjectCollectionView.snp.makeConstraints { make in
            make.centerX.centerY.height.width.equalToSuperview()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dayLessonsMockData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = subjectCollectionView.dequeueReusableCell(withReuseIdentifier: SubjectCollectionViewCell.identifier, for: indexPath) as? SubjectCollectionViewCell else {
            return SubjectCollectionViewCell(frame: .zero)
        }
        let ind = indexPath.item
        let lessonsDay = dayLessonsMockData[ind]
        cell.id = ind + 1
        cell.title = lessonsDay.subject.name
        cell.subtitle = "\(lessonsDay.startTime) - \(lessonsDay.endTime) · Кабинет: \(lessonsDay.room.name)"
        cell.descr = "Задано: \(lessonsDay.homework?.text ?? "-")"
        cell.setGrade(to: .four)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width-32, height: 75)
    }
        
    
}
