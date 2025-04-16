import SnapKit
import UIKit

class NotificationsOverviewViewController: DetailViewController {
    private let viewModel: NotificationsViewModel
    private let performanceAPI: PerformanceAPIProtocol

    // MARK: Pagination
    private var isLoading = false
    private var currentPage = 1
    private var totalPages = 1

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

    init(viewModel: NotificationsViewModel, performanceAPI: PerformanceAPIProtocol) {
        self.viewModel = viewModel
        self.performanceAPI = performanceAPI
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
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
        self.notepadView.isHidden = !viewModel.notifications.isEmpty
        self.notificationsCollectionView.isHidden = viewModel.notifications.isEmpty
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
}

extension NotificationsOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel.notifications.count
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let notification = viewModel.notifications[indexPath.item]
        guard let cell = notificationsCollectionView
            .dequeueReusableCell(
                withReuseIdentifier: NotificationCollectionViewCell.identifier,
                for: indexPath
            ) as? NotificationCollectionViewCell else { return NotificationCollectionViewCell(frame: .zero) }
        cell.id = notification.id
        cell.isRead = notification.isRead
        cell.date = notification.date
        cell.text = notification.text
        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: 100, height: 100) // The size defines automatically, but we need an initial size bigger than all cell's elements to avoid yellow SnapKit errors at the console.
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let notification = viewModel.notifications[indexPath.item]
        let notificationVC = NotificationDetailViewController(viewModel: self.viewModel, notification: notification, performanceAPI: performanceAPI)
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height && !isLoading && currentPage < totalPages {
            currentPage += 1
            Task {
                do {
                    isLoading = true
                    self.totalPages = try await viewModel.getNotifications(currentPage: self.currentPage)
                    updateUI()
                    isLoading = false
                } catch { print(error) }
            }
        }
    }
}
