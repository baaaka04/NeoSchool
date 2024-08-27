import UIKit
import SnapKit

class SubjectDetailsStatefulViewController: DetailViewController {
    
    private let viewModel: SubjectDetailsViewModelRepresentable
    private let submittedVC: SubmittedSubjectDetailsViewController
    private let notSubmittedVC: NotSubmittedSubjectDetailsViewController
        
    init(viewModel: SubjectDetailsViewModelRepresentable) {
        self.viewModel = viewModel
        self.submittedVC = SubmittedSubjectDetailsViewController(viewModel: viewModel)
        self.notSubmittedVC = NotSubmittedSubjectDetailsViewController(viewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChild(notSubmittedVC)
        self.view.addSubview(notSubmittedVC.view)
        notSubmittedVC.didMove(toParent: self)
        
        self.addChild(submittedVC)
        self.view.addSubview(submittedVC.view)
        submittedVC.didMove(toParent: self)
        
        notSubmittedVC.getLessonDetails = {[weak self] in self?.getLessonDetails() }
        submittedVC.getLessonDetails = {[weak self] in self?.getLessonDetails() }
        
        notSubmittedVC.view.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
        }
        submittedVC.view.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
        }
        
        getLessonDetails()
    }
    
    private func getLessonDetails() {
        Task {
            try await viewModel.getLessonDetailData()
            self.submittedVC.updateUI()
            self.notSubmittedVC.updateUI()
            self.submittedVC.view.isHidden = !self.viewModel.isSubmitted
            self.notSubmittedVC.view.isHidden = self.viewModel.isSubmitted
        }
    }

}
