import UIKit
import SnapKit

class NotificationDetailViewController: DetailViewController {
    
    private let notification: NeobisNotificationToPresent
    
    private lazy var textLabel: GrayUILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .Medium, size: 20)
        label.numberOfLines = 0
        label.text = self.notification.text
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Regular, size: 16)
        label.textColor = .neobisLightGray
        label.text = self.notification.date
        return label
    }()
    
    private lazy var teacherCommentView: CommentView = {
        let view = CommentView(author: .teacher, text: notification.teacherComment)
        return view
    }()
    
    private lazy var navigateButton : NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        switch self.notification.type {
        case .rate_classwork, .rate_homework, .submit_homework:
            button.setTitle("Просмотреть задание", for: .normal)
        case .rate_quarter, .revise_homework:
            button.setTitle("Просмотреть оценки по этому предмету", for: .normal)
        }
        button.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
        return button
    }()
    
    init(notification: NeobisNotificationToPresent) {
        self.notification = notification
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {

        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(24)
            make.width.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        }
        if self.notification.type == .rate_homework {
            view.addSubview(teacherCommentView)
            teacherCommentView.snp.makeConstraints { make in
                make.top.equalTo(dateLabel.snp.bottom).offset(24)
                make.width.equalToSuperview().inset(32)
                make.centerX.equalToSuperview()
            }
        }
        let lastConstraint = self.notification.type == .rate_homework ? teacherCommentView.snp.bottom : dateLabel.snp.bottom
        
        view.addSubview(navigateButton)
        navigateButton.snp.makeConstraints { make in
            make.top.equalTo(lastConstraint).offset(24)
            make.width.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }
    }
    
    @objc private func onTapButton() {
        switch self.notification.type {
        case .rate_homework:
            print("rate_homework")
        case .rate_classwork:
            print("rate_classwork")
        case .revise_homework:
            print("revise_homework")
        case .rate_quarter:
            print("rate_quarter")
        case .submit_homework:
            print("submit_homework")
        }
    }

}
