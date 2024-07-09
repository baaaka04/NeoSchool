import UIKit
import SnapKit

class NotificationsOverviewViewController: DetailViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NotificationsRefreshable {

    private let viewModel : NotificationsViewModel
        
    private lazy var notificationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.layer.masksToBounds = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: NotificationCollectionViewCell.identifier)
        return collectionView
    }()
    
    init(viewModel: NotificationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        if !viewModel.isLoading {
            viewModel.getNotifications()
        }
    }
    
    func setupUI() {
                        
        view.addSubview(notificationsCollectionView)
        
        notificationsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
        
    func updateNotifications() {
        self.notificationsCollectionView.reloadData()
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = notificationsCollectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.identifier, for: indexPath) as? NotificationCollectionViewCell
        else { return NotificationCollectionViewCell(frame: .zero) }
        let notification = viewModel.notifications[indexPath.item]
        cell.id = notification.id
        cell.isRead = notification.isRead
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: notification.date)
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: notification.date)
        
        cell.date = formattedDate + " в " + formattedTime
        
        cell.text = notification.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height, !viewModel.isLoading {
            viewModel.loadMoreNotifications()
        }
    }
    
}
