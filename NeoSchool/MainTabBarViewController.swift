import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = self.createVC(with: "Расписание", image: UIImage(named: "ScheduleIcon"), selectedImage: UIImage(named: "ScheduleIconSelected"), vc: ScheduleViewController(navbarTitle: "Расписание", navbarColor: .neobisPurple))
        let vc2 = self.createVC(with: "Успеваемость", image: UIImage(named: "LineChartIcon"), selectedImage: UIImage(named: "LineChartIconSelected"), vc: PerformanceViewController(navbarTitle: "Успеваемость", navbarColor: .neobisBlue))
        let vc3 = self.createVC(with: "Профиль", image: UIImage(named: "ProfileIcon"), selectedImage: UIImage(named: "ProfileIconSelected"), vc: ProfileViewController(navbarTitle: "Профиль", navbarColor: .neobisGreen, isTeacher: false))
        
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
        
    private func createVC(with title: String, image: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> NeobisUINavigationController {
        
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = selectedImage
        
        return NeobisUINavigationController(rootViewController: vc)
    }
    
    @objc private func onTapProfileOptions () {
        
    }


}

