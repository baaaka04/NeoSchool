import UIKit
import SnapKit

protocol Confirmable: AnyObject {
    var view: UIView! { get }
}

extension Confirmable where Self: UIViewController {

    func showConfirmView(title: String, text: String?, confirmButtonText: String, declineButtonText: String, confirmedAction: @escaping (() -> Void)) {

        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                window.showConfirmView(title: title, text: text, confirmButtonText: confirmButtonText, declineButtonText: declineButtonText, confirmedAction: confirmedAction)
            }
        }
    }
}

extension UIWindow {
    
    func showConfirmView(title: String, text: String?, confirmButtonText: String, declineButtonText: String, confirmedAction: @escaping (() -> Void)) {
        
        let confirmView = ConfirmUIView(title: title, text: text, confirmButtonText: confirmButtonText, declineButtonText: declineButtonText, confirmedAction: confirmedAction)
        confirmView.frame = self.bounds
        self.addSubview(confirmView)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            confirmView.modalView.snp.updateConstraints { $0.bottom.equalToSuperview().offset(-40) }
            confirmView.layoutIfNeeded()
        }
    }
}
