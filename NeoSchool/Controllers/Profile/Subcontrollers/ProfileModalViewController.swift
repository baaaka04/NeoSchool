import SnapKit
import UIKit

class ProfileModalViewController: UIViewController, Confirmable {
    private let submitView = ProfileSubmitView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSubmitView))
        view.addGestureRecognizer(tapGesture)

        view.addSubview(submitView)
        submitView.changePassword = { [weak self] in
            let changePasswordVC = ChangePasswordViewController()
            self?.navigationController?.pushViewController(changePasswordVC, animated: true)
        }
        submitView.logout = { [weak self] in
            self?.showConfirmView(title: "Выйти из аккаунта?",
                                  text: nil,
                                  confirmButtonText: "Да, выйти",
                                  declineButtonText: "Отмена") {
                KeychainHelper.delete(key: .accessToken)
                KeychainHelper.delete(key: .refreshToken)
                if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        submitView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.width.centerX.equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.submitView.snp.removeConstraints()
            self.submitView.snp.makeConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom)
                make.width.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc private func hideSubmitView() {
        UIView.animate(withDuration: 0.3) {
            self.submitView.snp.removeConstraints()
            self.submitView.snp.makeConstraints { make in
                make.top.equalTo(self.view.snp.bottom)
                make.width.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        } completion: { _ in self.dismiss(animated: false, completion: nil)
        }
    }
}
