import SnapKit
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let authService = AuthService()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        self.window = window
        window.makeKeyAndVisible()

        checkAuthentication()
    }

    func checkAuthentication() { // Keep it public for login/logout/changePassword

        guard let userRoleString = UserDefaults.standard.string(forKey: "userRole"),
              let userRole = UserRole(rawValue: userRoleString) else {
            transitionToRootViewController(WelcomeViewController())
            return
        }

        Task {
            do {
                let isAuthenticated = try await authService.refreshAccessToken()
                let rootVC = isAuthenticated ? MainTabBarViewController(userRole: userRole) : WelcomeViewController()
                transitionToRootViewController(rootVC)
            } catch {
                print("Auth error: \(error)")
                transitionToRootViewController(WelcomeViewController())
            }
        }
    }

    private func transitionToRootViewController(_ viewController: UIViewController) {
        let newRootVC = (viewController is WelcomeViewController) ?
            UINavigationController(rootViewController: viewController) :
            viewController

        guard let window else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = newRootVC
        }
    }
}
