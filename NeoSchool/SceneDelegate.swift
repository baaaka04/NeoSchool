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
                
        let authService = AuthService()
        
        Task {
            try await authService.refreshAccessToken { [weak self] done in
                
                DispatchQueue.main.async { [weak self] in
                    
                    UIView.animate(withDuration: 0.25) {
                        self?.window?.layer.opacity = 0
                    } completion: { [weak self] _ in
                        
                        let welcomeNavVC = UINavigationController(rootViewController: WelcomeViewController())
                        
                        //If it's authorized user then MainTabBarVC, if not - WelcomeVC
                        let rootViewController = done ? MainTabBarViewController() : welcomeNavVC
                        rootViewController.modalPresentationStyle = .fullScreen
                        self?.window?.rootViewController = rootViewController
                        
                        UIView.animate(withDuration: 0.25) { [weak self] in
                            self?.window?.layer.opacity = 1
                        }
                    }
                }
                
            }
        }
    }

}

