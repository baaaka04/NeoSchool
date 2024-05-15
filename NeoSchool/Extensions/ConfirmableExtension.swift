import UIKit
import SnapKit

protocol Confirmable: AnyObject {
    var view: UIView! { get }
}

extension Confirmable where Self: UIViewController {

    func showConfirmView(title: String, text: String?, confirmButtonText: String, declineButtonText: String, confirmedAction: @escaping (() -> Void)) {
        let confirmView = ConfirmUIView(title: title, text: text, confirmButtonText: confirmButtonText, declineButtonText: declineButtonText, confirmedAction: confirmedAction)
        confirmView.frame = view.bounds
        view.addSubview(confirmView)
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            confirmView.modalView.snp.updateConstraints { $0.bottom.equalToSuperview().offset(-40) }
            confirmView.layoutIfNeeded()
        }
    }
}
