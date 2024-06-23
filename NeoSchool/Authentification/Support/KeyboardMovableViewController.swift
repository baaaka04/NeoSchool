import UIKit
import SnapKit

class KeyboardMovableViewController: DetailViewController {
    
    let titleLabel: BigSemiBoldUILabel = {
        let label = BigSemiBoldUILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var titleText: String? {
        didSet {
            self.titleLabel.text = titleText
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(self.view.frame.height / 5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-116)
        }
    }

}

//MARK: - Keyboard handlers
extension KeyboardMovableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if UIScreen.main.bounds.width <= 375 {
            titleLabel.snp.updateConstraints { $0.top.equalTo(self.view.snp.top).offset(15) }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        titleLabel.snp.updateConstraints { $0.top.equalTo(self.view.snp.top).offset(self.view.frame.height / 5) }
    }
}
