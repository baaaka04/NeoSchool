import UIKit
import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        window?.windowScene = windowsScene
        window?.makeKeyAndVisible()
        
        self.checkAuthentication()
    }
    
    public func checkAuthentication() {
        
//        KeychainHelper.delete(key: .accessToken)
//        KeychainHelper.delete(key: .refreshToken)
        
        let authService = AuthService()
        
        Task {
            try await authService.refreshAccessToken { [weak self] done in
                DispatchQueue.main.sync {
                    if done {
                        self?.goToController(with: MainTabBarViewController(), isAuthorized: true)
                    } else {
                        self?.goToController(with: WelcomeViewController(), isAuthorized: false)
                    }
                }
            }
        }
    }
    
    @objc private func onPressNotifications() {}
    
    private func goToController(with viewController: UIViewController, isAuthorized: Bool) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
                
            } completion: { [weak self] _ in
                guard let strongSelf = self else { return }
                var nav = UINavigationController(rootViewController: viewController)
                
                if isAuthorized {
                    nav = strongSelf.addNavbar(to: nav)
                }
                
                nav.modalPresentationStyle = .fullScreen
                strongSelf.window?.rootViewController = nav
                
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
    
    private func addNavbar(to navController: UINavigationController) -> UINavigationController {
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(self.onPressNotifications))
        notificationButton.tintColor = .white
        navController.navigationBar.topItem?.rightBarButtonItem = notificationButton
        
        let titleView = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "Привет, Айсулуу!"
        titleLabel.font = AppFont.font(type: .Medium, size: 20)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        let buttonTitle = UIBarButtonItem(customView: titleView)
        navController.navigationBar.topItem?.leftBarButtonItem = buttonTitle
        return navController
    }


}

