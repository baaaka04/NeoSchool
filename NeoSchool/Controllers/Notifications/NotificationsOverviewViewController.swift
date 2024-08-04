import UIKit
import SnapKit

class NotificationsOverviewViewController: DetailViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NotificationsRefreshable {

    private let viewModel : NotificationsViewModelProtocol
        
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
    
    init(viewModel: NotificationsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !viewModel.isLoading {
            viewModel.getNotifications()
        }
    }
    
    private func showEmptyScreen() {
        let imageView = UIImageView(image: UIImage(named: "Notepad"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(134)
        }
        let titleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 22))
        titleLabel.text = "Уведомлений еще нет"
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.width.equalToSuperview()
        }
        let subtitleLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))
        subtitleLabel.text = "Здесь будут показаны уведомления"
        subtitleLabel.textAlignment = .center
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalToSuperview()
        }
    }
    
    private func setupUI() {
                        
        view.addSubview(notificationsCollectionView)
        
        notificationsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func checkNotifications() {
        if let notifications = viewModel.notifications, !notifications.isEmpty {
            setupUI()
        } else {
            showEmptyScreen()
        }
    }
        
    func updateNotifications() {
        self.notificationsCollectionView.reloadData()
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.notifications?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = notificationsCollectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.identifier, for: indexPath) as? NotificationCollectionViewCell,
              let notification = viewModel.notifications?[indexPath.item]
        else { return NotificationCollectionViewCell(frame: .zero) }
        cell.id = notification.id
        cell.isRead = notification.isRead
        cell.date = notification.date
        cell.text = notification.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let notification = viewModel.notifications?[indexPath.item] else { return }
        let notificationVC = NotificationDetailViewController(notification: notification)
        self.navigationController?.pushViewController(notificationVC, animated: true)
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
