import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = self.createNav(with: "Расписание", image: UIImage(named: "ScheduleIcon"), selectedImage: UIImage(named: "ScheduleIconSelected"), vc: ScheduleViewController(navbarTitle: "Расписание"))
        let vc2 = self.createNav(with: "Успеваемость", image: UIImage(named: "LineChartIcon"), selectedImage: UIImage(named: "LineChartIconSelected"), vc: PerformanceViewController(navbarTitle: "Успеваемость"))
        let vc3 = self.createNav(with: "Профиль", image: UIImage(named: "ProfileIcon"), selectedImage: UIImage(named: "ProfileIconSelected"), vc: ProfileViewController(navbarTitle: "Профиль"))
        
        self.tabBar.tintColor = UIColor(named: "IconsColor")
        
        self.setViewControllers([vc1, vc2, vc3], animated: true)
    }
    
    @objc private func onPressNotifications() {
        
    }
    
    private func createNav(with title: String, image: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(onPressNotifications))
        notificationButton.tintColor = .white
        nav.navigationBar.topItem?.rightBarButtonItem = notificationButton
        nav.title = title
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = selectedImage
        
        return nav
    }


}

