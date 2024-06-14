import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = self.createVC(with: "Расписание", image: UIImage(named: "ScheduleIcon"), selectedImage: UIImage(named: "ScheduleIconSelected"), vc: ScheduleViewController(navbarTitle: "Расписание", navbarColor: .neobisPurple))
        let vc2 = self.createVC(with: "Успеваемость", image: UIImage(named: "LineChartIcon"), selectedImage: UIImage(named: "LineChartIconSelected"), vc: PerformanceViewController(navbarTitle: "Успеваемость", navbarColor: .neobisBlue))
        let vc3 = self.createVC(with: "Профиль", image: UIImage(named: "ProfileIcon"), selectedImage: UIImage(named: "ProfileIconSelected"), vc: ProfileViewController(navbarTitle: "Профиль", navbarColor: .neobisGreen))
        
        self.tabBar.tintColor = UIColor.neobisDarkPurple
        self.tabBar.barTintColor = .white
        
        self.setViewControllers([vc1, vc2, vc3], animated: true)
    }
        
    private func createVC(with title: String, image: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> UIViewController {
        
        vc.title = title
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = selectedImage
        return vc
    }

}

