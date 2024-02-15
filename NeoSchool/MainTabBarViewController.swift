import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = self.createNav(with: "Расписание", image: UIImage(named: "ScheduleIcon"), selectedImage: UIImage(named: "ScheduleIconSelected"), vc: ScheduleViewController(navbarTitle: "Расписание", navbarColor: .neobisPurple))
        let vc2 = self.createNav(with: "Успеваемость", image: UIImage(named: "LineChartIcon"), selectedImage: UIImage(named: "LineChartIconSelected"), vc: PerformanceViewController(navbarTitle: "Успеваемость", navbarColor: .neobisBlue))
        let vc3 = self.createNav(with: "Профиль", image: UIImage(named: "ProfileIcon"), selectedImage: UIImage(named: "ProfileIconSelected"), vc: ProfileViewController(navbarTitle: "Профиль", navbarColor: .neobisGreen))
        
        self.tabBar.tintColor = UIColor(named: "IconsColor")
        self.tabBar.barTintColor = .white
        
        self.setViewControllers([vc1, vc2, vc3], animated: true)
    }
    
    @objc private func onPressNotifications() {
        
    }
    
    private func createNav(with title: String, image: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(onPressNotifications))
        notificationButton.tintColor = .white
        nav.navigationBar.topItem?.rightBarButtonItem = notificationButton
        
        let titleView = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "Привет, Айсулуу!"
        titleLabel.font = UIFont(name: "Jost-Medium", size: 20)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        let buttonTitle = UIBarButtonItem(customView: titleView)
        nav.navigationBar.topItem?.leftBarButtonItem = buttonTitle
        nav.title = title
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = selectedImage
        
        return nav
    }


}

