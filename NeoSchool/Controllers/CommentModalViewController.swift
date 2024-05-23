import UIKit
import SnapKit

protocol CommentRepresentable: AnyObject {
    func sendFiles() async throws
    var studentComment: String? { get set }
}

class CommentModalViewController: UIViewController, Notifiable {    
    
    private let commentView = CommentSubmitView()
    
    weak var delegate: CommentRepresentable?
    var getLessonDetails: (() -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideCommentView))
        view.addGestureRecognizer(tapGesture)

        view.addSubview(commentView)
        commentView.uploadFiles = { [weak self] in
            Task {
                do {
                    guard let strongSelf = self else { return }
                    let commentText = strongSelf.commentView.commentInput.text
                    strongSelf.delegate?.studentComment = commentText == "" ? nil : commentText
                    try await strongSelf.delegate?.sendFiles()
                    strongSelf.hideCommentView()
                    strongSelf.getLessonDetails?()
                    self?.showNotification(message: "Задание успешно отправлено", isSucceed: true)
                } catch {
                    print(error)
                    self?.showNotification(message: "Произошла ошибка", isSucceed: false)
                }
            }
        }
        commentView.snp.makeConstraints { make in
            make.height.equalTo(374)
            make.top.equalTo(view.snp.bottom)
            make.width.centerX.equalToSuperview()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.commentView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-374)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func hideCommentView() {
        UIView.animate(withDuration: 0.3) {
            self.commentView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom)
            }
            self.view.layoutIfNeeded()
        } completion: { _ in self.dismiss(animated: false, completion: nil) }
    }

}

//MARK: - Keyboard handlers
extension CommentModalViewController {

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
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            commentView.snp.updateConstraints {
                $0.top.equalTo(self.view.snp.bottom).offset( -(374+keyboardSize.height-32) )
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        commentView.snp.updateConstraints { $0.top.equalTo(self.view.snp.bottom).offset(-374) }
    }
}
