import UIKit

protocol Notifiable: AnyObject {
    var view: UIView! { get }
}

extension Notifiable where Self: UIViewController {
    func showNotification(message: String, isSucceed: Bool, duration: TimeInterval = 3.0 ) {
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if let window = windowScene.windows.first(where: \.isKeyWindow) {
                window.showNotification(message: message, isSucceed: isSucceed, duration: duration)
            }
        }
    }
}

extension UIWindow {
    func showNotification(message: String, isSucceed: Bool, duration: TimeInterval) {
        let snackbarView = SnackBarView(text: message, isSucceed: isSucceed)
        snackbarView.frame = CGRect(x: 16, y: -100, width: self.frame.width - 32, height: 58)
        self.addSubview(snackbarView)

        UIView.animate(withDuration: 0.5, animations: {
            snackbarView.frame.origin.y = 50
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: [], animations: {
                snackbarView.frame.origin.y = -100
            }, completion: { _ in
                snackbarView.removeFromSuperview()
            })
        }
    }
}
