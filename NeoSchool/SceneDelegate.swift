import SnapKit
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        window?.windowScene = windowsScene
        window?.makeKeyAndVisible()

        self.checkAuthentication()
    }

    func checkAuthentication() {
        let authService = AuthService()
        guard let userRoleString = UserDefaults.standard.string(forKey: "userRole"),
              let userRole = UserRole(rawValue: userRoleString) else {
            goToWelcomeScreen()
            return
        }

        Task {
            do {
                try await authService.refreshAccessToken { [weak self] done in
                    DispatchQueue.main.async { [weak self] in
                        UIView.animate(withDuration: 0.25) {
                            self?.window?.layer.opacity = 0
                        } completion: { [weak self] _ in
                            // If it's authorized user then MainTabBarVC, if not - WelcomeVC
                            if done {
                                let rootViewController = MainTabBarViewController(userRole: userRole)
                                rootViewController.modalPresentationStyle = .fullScreen
                                self?.window?.rootViewController = rootViewController
                            } else {
                                self?.goToWelcomeScreen()
                            }

                            UIView.animate(withDuration: 0.25) { [weak self] in
                                self?.window?.layer.opacity = 1
                            }
                        }
                    }
                }
            } catch { print(error) }
        }
    }

    private func goToWelcomeScreen() {
        let welcomeNavVC = UINavigationController(rootViewController: WelcomeViewController())
        welcomeNavVC.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = welcomeNavVC
    }
}
