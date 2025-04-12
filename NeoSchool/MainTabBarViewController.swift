import UIKit

class MainTabBarViewController: UITabBarController {
    private let userRole: UserRole
    private let authService: AuthServiceProtocol

    var checkAuthentication: (() -> Void)?

    init(userRole: UserRole, authService: AuthServiceProtocol) {
        self.userRole = userRole
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let (navControllerName, navControllerIcon, navControllerIconSelected) = getNavControllerDetails(for: userRole)

        let vc1 = self.createVC(
            with: "Расписание",
            image: UIImage(named: Asset.scheduleIcon),
            selectedImage: UIImage(named: Asset.scheduleIconSelected),
            vc: ScheduleViewController(
                navbarTitle: "Расписание",
                navbarColor: .neobisPurple,
                userRole: self.userRole
            )
        )
        let vc2teacher = self.createVC(
            with: navControllerName,
            image: navControllerIcon,
            selectedImage: navControllerIconSelected,
            vc: TeacherPerformanceViewController(
                navbarTitle: navControllerName,
                navbarColor: .neobisBlue,
                performanceAPI: PerformanceAPI()
            )
        )
        let vc2student = self.createVC(
            with: navControllerName,
            image: navControllerIcon,
            selectedImage: navControllerIconSelected,
            vc: StudentPerformanceViewController(
                navbarTitle: navControllerName,
                navbarColor: .neobisBlue,
                performanceAPI: PerformanceAPI()
            )
        )
        let vc3 = self.createVC(
            with: "Профиль",
            image: UIImage(named: Asset.profileIcon),
            selectedImage: UIImage(named: Asset.profileIconSelected),
            vc: ProfileViewController(
                authService: self.authService,
                navbarTitle: "Профиль",
                navbarColor: .neobisGreen
            )
        )

        self.tabBar.tintColor = UIColor.neobisDarkPurple

        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBar.standardAppearance
            }
        } else {
            tabBar.barTintColor = .white
        }

        // Adding one more button for the ProfileViewController
        let optionsButton = UIBarButtonItem(
            image: UIImage(named: Asset.verticaldots),
            style: .plain,
            target: self,
            action: #selector(onTapProfileOptions)
        )
        optionsButton.tintColor = .white
        vc3.topViewController?.navigationItem.rightBarButtonItems?.insert(optionsButton, at: 0)

        switch userRole {
        case .teacher:
            self.setViewControllers([vc1, vc2teacher, vc3], animated: true)
        case .student:
            self.setViewControllers([vc1, vc2student, vc3], animated: true)
        }
    }

    private func getNavControllerDetails(for role: UserRole) -> (String, UIImage?, UIImage?) {
            switch role {
            case .teacher:
                return ("Журнал", UIImage(named: Asset.bookIcon), UIImage(named: Asset.bookIconSelected))
            case .student:
                return ("Успеваемость", UIImage(named: Asset.lineChartIcon), UIImage(named: Asset.lineChartIconSelected))
            }
        }

    private func createVC(with title: String, image: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> NeobisUINavigationController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = selectedImage

        return NeobisUINavigationController(authService: authService, rootViewController: vc)
    }

    @objc private func onTapProfileOptions () {
        let submitVC = ProfileModalViewController(authService: authService)
        submitVC.checkAuthentication = { [weak self] in
            self?.checkAuthentication?()
        }
        let navVC = UINavigationController(rootViewController: submitVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: false)
    }
}
