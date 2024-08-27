import UIKit
import SnapKit

class HomeworkSubmissionViewController: UIViewController {

    weak var viewModel : HomeworkSubmissionRepresentable?
    let studentFilesVC : FilesCollectionViewController
    
    private lazy var studentCommentView = CommentView(author: .mineAsStudent, text: self.viewModel?.studentCommentSubmitted)
    private lazy var teacherCommentView = CommentView(author: .teacher, text: self.viewModel?.teacherComment)
    
    init(viewModel: HomeworkSubmissionRepresentable?) {
        self.viewModel = viewModel
        self.studentFilesVC = FilesCollectionViewController(urls: viewModel?.files)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(studentCommentView)
        if self.viewModel?.teacherComment != nil { setupTeacherCommentUI() }
        
        addChild(studentFilesVC)
        view.addSubview(studentFilesVC.view)
        studentFilesVC.didMove(toParent: self)
        
        studentCommentView.translatesAutoresizingMaskIntoConstraints = false
        
        studentCommentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        let lastConstraint : ConstraintItem = {
            if self.viewModel?.teacherComment != nil {
                return teacherCommentView.snp.bottom
            } else {
                return studentCommentView.snp.bottom
            }
        }()
        studentFilesVC.view.snp.makeConstraints { make in
            make.top.equalTo(lastConstraint).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupTeacherCommentUI() {
        view.addSubview(teacherCommentView)
        teacherCommentView.snp.makeConstraints { make in
            make.top.equalTo(studentCommentView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
    }
    
}
