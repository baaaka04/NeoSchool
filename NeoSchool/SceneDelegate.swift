import SnapKit
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let authService = AuthService()
    private let performanceAPI = PerformanceAPI()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        self.window = window
        window.makeKeyAndVisible()

        checkAuthentication()
    }

    private func checkAuthentication() {
        let welcomeVC = WelcomeViewController(authService: authService)
        welcomeVC.checkAuthentication = { [weak self] in
            self?.checkAuthentication()
        }
        guard let userRoleString = UserDefaults.standard.string(forKey: "userRole"),
              let userRole = UserRole(rawValue: userRoleString) else {
            transitionToRootViewController(welcomeVC)
            return
        }

        Task {
            do {
                let isAuthenticated = try await authService.refreshAccessToken()
                let mainTabBarVC = MainTabBarViewController(userRole: userRole, authService: authService, performanceAPI: performanceAPI)
                mainTabBarVC.checkAuthentication = { [weak self] in
                    self?.checkAuthentication()
                }
                let rootVC = isAuthenticated ? mainTabBarVC : welcomeVC
                transitionToRootViewController(rootVC)
            } catch {
                print("Auth error: \(error)")
                transitionToRootViewController(welcomeVC)
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
