import UIKit

class MainTabBarViewController: UITabBarController {
    
    private let userRole: UserRole
    
    init(userRole: UserRole) {
        self.userRole = userRole
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let (navControllerName, navControllerIcon, navControllerIconSelected) = getNavControllerDetails(for: userRole)

        let vc1 = self.createVC(with: "Расписание", image: UIImage(named: "ScheduleIcon"), selectedImage: UIImage(named: "ScheduleIconSelected"), vc: ScheduleViewController(navbarTitle: "Расписание", navbarColor: .neobisPurple, userRole: self.userRole))
        let vc2 = self.createVC(with: navControllerName, image: navControllerIcon, selectedImage: navControllerIconSelected, vc: PerformanceViewController(navbarTitle: navControllerName, navbarColor: .neobisBlue))
        let vc3 = self.createVC(with: "Профиль", image: UIImage(named: "ProfileIcon"), selectedImage: UIImage(named: "ProfileIconSelected"), vc: ProfileViewController(navbarTitle: "Профиль", navbarColor: .neobisGreen))
        
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

        //Adding one more button for the ProfileViewController
        let optionsButton = UIBarButtonItem(image: UIImage(named: "verticaldots"), style: .plain, target: self, action: #selector(onTapProfileOptions))
        optionsButton.tintColor = .white
        vc3.topViewController?.navigationItem.rightBarButtonItems?.insert(optionsButton, at: 0)
        
        self.setViewControllers([vc1, vc2, vc3], animated: true)
    }

    private func getNavControllerDetails(for role: UserRole) -> (String, UIImage?, UIImage?) {
            switch role {
            case .teacher:
                return ("Журнал", UIImage(named: "BookIcon"), UIImage(named: "BookIconSelected"))
            case .student:
                return ("Успеваемость", UIImage(named: "LineChartIcon"), UIImage(named: "LineChartIconSelected"))
            }
        }

    private func createVC(with title: String, image: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> NeobisUINavigationController {
        
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = selectedImage
        
        return NeobisUINavigationController(rootViewController: vc)
    }
    
    @objc private func onTapProfileOptions () {
        let submitVC = ProfileModalViewController()
        let navVC = UINavigationController(rootViewController: submitVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: false)
    }


}

