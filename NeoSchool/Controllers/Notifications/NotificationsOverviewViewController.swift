import UIKit
import SnapKit

class NotificationsOverviewViewController: DetailViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let viewModel: NotificationsViewModel

    //MARK: Pagination
    private var isLoading: Bool = false
    private var currentPage: Int = 1
    private var totalPages: Int = 1

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

    private let notepadView = NotepadView(title: "Уведомлений еще нет", subtitle: "Здесь будут показаны уведомления")

    init(viewModel: NotificationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.notifications = []
        
        setupUI()
        getNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        getNotifications()
    }

    private func setupUI() {
        view.addSubview(notificationsCollectionView)
        notificationsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }

        view.addSubview(notepadView)
        notepadView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    private func updateUI() {
        self.notificationsCollectionView.reloadData()
        self.notepadView.isHidden = viewModel.notifications.count != 0
        self.notificationsCollectionView.isHidden = viewModel.notifications.count == 0
    }

    private func getNotifications() {
        if !isLoading {
            Task {
                do {
                    isLoading = true
                    self.totalPages = try await viewModel.getNotifications(currentPage: self.currentPage)
                    updateUI()
                } catch { print(error) }
                isLoading = false
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let notification = viewModel.notifications[indexPath.item]
        guard let cell = notificationsCollectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.identifier, for: indexPath) as? NotificationCollectionViewCell else { return NotificationCollectionViewCell(frame: .zero) }
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
        let notification = viewModel.notifications[indexPath.item]
        let notificationVC = NotificationDetailViewController(viewModel: self.viewModel, notification: notification)
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height && !isLoading && currentPage < totalPages {
            currentPage += 1
            Task {
                isLoading = true
                self.totalPages = try await viewModel.getNotifications(currentPage: self.currentPage)
                updateUI()
                isLoading = false
            }
        }
    }
    
}
