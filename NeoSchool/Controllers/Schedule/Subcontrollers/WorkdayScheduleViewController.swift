import UIKit

class WorkdayScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var weekCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemPink
        collectionView.register(WeekdayCollectionViewCell.self, forCellWithReuseIdentifier: WeekdayCollectionViewCell.identifier)
        return collectionView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        view.addSubview(weekCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        weekCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(view.frame.size.height / 2)
            make.centerX.equalTo(view.frame.size.width / 2)
            make.height.equalTo(48)
            make.width.equalTo(view.frame.size.width - 16.0 * 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCollectionViewCell.identifier, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: weekCollectionView.frame.size.width/6, height: weekCollectionView.frame.size.height)
    }
}
