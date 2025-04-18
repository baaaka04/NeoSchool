import SnapKit
import UIKit

protocol Confirmable: AnyObject {
    var view: UIView! { get }
}

extension Confirmable where Self: UIViewController {
    func showConfirmView(title: String, text: String?, confirmButtonText: String, declineButtonText: String, confirmedAction: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                if let window = windowScene.windows.first(where: \.isKeyWindow) {
                    window.showConfirmView(title: title,
                                           text: text,
                                           confirmButtonText: confirmButtonText,
                                           declineButtonText: declineButtonText,
                                           confirmedAction: confirmedAction)
                }
            }
        }
    }

    func showConfirmView(confirmedAction: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                if let window = windowScene.windows.first(where: \.isKeyWindow) {
                    window.showConfirmView(confirmedAction: confirmedAction)
                }
            }
        }
    }
}

extension UIWindow {
    func showConfirmView(title: String, text: String?, confirmButtonText: String, declineButtonText: String, confirmedAction: @escaping (() -> Void)) {
        let confirmView = ConfirmUIView(title: title,
                                        text: text,
                                        confirmButtonText: confirmButtonText,
                                        declineButtonText: declineButtonText,
                                        confirmedAction: confirmedAction)
        confirmView.frame = self.bounds
        self.addSubview(confirmView)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            confirmView.modalView.snp.updateConstraints { $0.bottom.equalToSuperview().offset(-40) }
            confirmView.layoutIfNeeded()
        }
    }

    func showConfirmView(confirmedAction: @escaping (() -> Void)) {
        let confirmView = PasswordHasChangedView(confirmedAction: confirmedAction)
        confirmView.frame = self.bounds
        self.addSubview(confirmView)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            confirmView.modalView.snp.updateConstraints { $0.bottom.equalToSuperview().offset(-40) }
            confirmView.layoutIfNeeded()
        }
    }
}
