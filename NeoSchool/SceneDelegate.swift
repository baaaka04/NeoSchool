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
                        self?.goToController(with: MainTabBarViewController())
                    } else {
                        self?.goToController(with: WelcomeViewController())
                    }
                }
            }
        }
    }
    
    private func goToController(with viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
                
            } completion: { [weak self] _ in
                guard let strongSelf = self else { return }
                viewController.modalPresentationStyle = .fullScreen
                strongSelf.window?.rootViewController = viewController
                
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }


}

