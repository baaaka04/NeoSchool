import SnapKit
import UIKit

class NeobisUINavigationController: UINavigationController {
    private let authService: AuthServiceProtocol
    private let performanceAPI: PerformanceAPIProtocol

    init(rootViewController: UIViewController, authService: AuthServiceProtocol, performanceAPI: PerformanceAPIProtocol) {
        self.authService = authService
        self.performanceAPI = performanceAPI
        super.init(rootViewController: rootViewController)

        let notificationButton = UIBarButtonItem(image: UIImage(named: Asset.bell),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(onPressNotifications))
        notificationButton.tintColor = UIColor.white
        self.navigationBar.topItem?.rightBarButtonItem = notificationButton

        let titleView = UIView()
        let titleLabel = UILabel()

        Task {
            do {
                let profileData = try await authService.getProfileData()
                await MainActor.run {
                    switch profileData.role {
                    case .teacher: titleLabel.text = "Здравствуйте, \(profileData.userFirstName)!"
                    case .student: titleLabel.text = "Привет, \(profileData.userFirstName)!"
                    }
                }
            } catch { print(error) }
        }
        titleLabel.font = AppFont.font(type: .medium, size: 20)
        titleLabel.textColor = .white
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }

        let buttonTitle = UIBarButtonItem(customView: titleView)
        self.navigationBar.topItem?.leftBarButtonItem = buttonTitle
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onPressNotifications () {
        let viewModel = NotificationsViewModel()
        let notificationsVC = NotificationsOverviewViewController(viewModel: viewModel, performanceAPI: performanceAPI)
        notificationsVC.title = "Уведомления"
        self.tabBarController?.tabBar.isHidden = true
        self.pushViewController(notificationsVC, animated: true)
    }
}
