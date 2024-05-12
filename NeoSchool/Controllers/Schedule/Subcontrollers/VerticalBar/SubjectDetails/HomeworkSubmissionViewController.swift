import UIKit
import SnapKit

class HomeworkSubmissionViewController: UIViewController {

    weak var viewModel : HomeworkSubmissionRepresentable?
    let studentFilesVC : FilesCollectionViewController
    
    private let commentView = CommentView()
    
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
        
        view.addSubview(commentView)
        addChild(studentFilesVC)
        view.addSubview(studentFilesVC.view)
        studentFilesVC.didMove(toParent: self)
        
        commentView.configure(author:.mineAsStudent, content: viewModel?.studentCommentSubmitted)
        commentView.translatesAutoresizingMaskIntoConstraints = false
        
        commentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        studentFilesVC.view.snp.makeConstraints { make in
            make.top.equalTo(commentView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}
