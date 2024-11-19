import SnapKit
import UIKit

protocol CommentRepresentableProtocol: AnyObject {
    func submit(_ submissionId: Int?) async throws

    var userComment: String? { get set }
    var grade: Grade? { get set }
}

class CommentModalViewController: UIViewController, Notifiable {
    private let commentViewHeight: CGFloat
    private let commentView: CommentSubmitView
    weak var delegate: CommentRepresentableProtocol?
    var getLessonDetails: (() -> Void)?
    private let submissionId: Int?
    private let succeedMessage: String

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
                    let grade = strongSelf.commentView.selectedGrade
                    strongSelf.delegate?.userComment = commentText == "" ? nil : commentText
                    strongSelf.delegate?.grade = grade
                    try await strongSelf.delegate?.submit(strongSelf.submissionId)
                    strongSelf.hideCommentView()
                    self?.showNotification(message: strongSelf.succeedMessage, isSucceed: true)
                    self?.getLessonDetails?()
                } catch {
                    print(error)
                    self?.showNotification(message: "Произошла ошибка", isSucceed: false)
                    self?.hideCommentView()
                    self?.getLessonDetails?()
                }
            }
        }
        commentView.snp.makeConstraints { make in
            make.height.equalTo( self.commentViewHeight )
            make.top.equalTo(view.snp.bottom)
            make.width.centerX.equalToSuperview()
        }
    }

    init(type: CommentType, submissionId: Int? = nil, commentInfo: CommentInfo? = nil) {
        self.submissionId = submissionId
        self.commentView = CommentSubmitView(type: type, commentInfo: commentInfo)

        switch type {
        case .teacherWithComment:
            self.commentViewHeight = 496
            self.succeedMessage = "Оценка успешна выставлена"
        case .studentWithComment:
            self.commentViewHeight = 374
            self.succeedMessage = "Задание успешно отправлено"
        case .teacherWithoutComment:
            self.commentViewHeight = 330
            self.succeedMessage = "Оценка успешна выставлена"
        case .teacherQuaterWithoutComment:
            self.commentViewHeight = 496
            self.succeedMessage = "Оценка успешна выставлена"
        }

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.commentView.snp.updateConstraints { make in
                make.top.equalTo(self.view.snp.bottom).offset(-self.commentViewHeight)
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
        } completion: { _ in self.dismiss(animated: false, completion: nil)
        }
    }
}

// MARK: - Keyboard handlers
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
                $0.top.equalTo(self.view.snp.bottom).offset( -(self.commentViewHeight + keyboardSize.height - 32) )
            }
        }
    }

    @objc func keyboardWillHide(_: Notification) {
        commentView.snp.updateConstraints { $0.top.equalTo(self.view.snp.bottom).offset(-self.commentViewHeight) }
    }
}
