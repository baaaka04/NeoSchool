import UIKit
import SnapKit

class SubmittedSubjectDetailsViewController: SubjectDetailsViewController, Notifiable, Confirmable {
    
    //MARK: - Properties
    
    private var homeworkSubmissionVC: HomeworkSubmissionViewController?
        
    lazy var cancelButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .white)
        button.setTitle("Отменить отправку", for: .normal)
        button.addTarget(self, action: #selector(cancelSubmission), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
            
    //MARK: - Initializers
    
    override init(viewModel: SubjectDetailsViewModelRepresentable) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCancelButtonUI()
        setupConstraints()
    }
    
    public func updateUI() {
        titleLabel.text = viewModel.subjectName
        firstSubTitleLabel.attributedText = viewModel.teacherName
        secondSubTitleLabel.attributedText = viewModel.homeworkTopic
        deadlineLabel.text = viewModel.homeworkDeadline
        markLabel.mark = viewModel.homeworkMark
        
        homeworkPanel.homeworkText = viewModel.homeworkText
        homeworkPanel.attachedFilesNumber = viewModel.homeworkFileURLs?.count
        
        setupHomeworkSubmissionUI()
        self.cancelButton.isHidden = !(self.viewModel.isCancelable ?? false)
    }
        
    private func setupHomeworkSubmissionUI() {
        //Checking: if homeworkSubmissionVC exists, then remove it
        if self.homeworkSubmissionVC != nil {
            self.homeworkSubmissionVC?.view.removeFromSuperview()
            self.homeworkSubmissionVC?.removeFromParent()
            self.homeworkSubmissionVC = nil
        }
        self.homeworkSubmissionVC = HomeworkSubmissionViewController(viewModel: self.viewModel as? HomeworkSubmissionRepresentable)
        guard let homeworkSubmissionVC else { return }
        self.addChild(homeworkSubmissionVC)
        scrollView.addSubview(homeworkSubmissionVC.view)
        homeworkSubmissionVC.didMove(toParent: self)
                
        homeworkSubmissionVC.view.snp.makeConstraints { make in
            make.top.equalTo(markLabel.snp.bottom).offset(Constants.gap)
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.centerX.bottom.equalToSuperview()
            if let num = viewModel.files?.count {
                // 64 - cell height; 8 - cells gap; 150 - commentView; 100 - additional height to activate scroll after the 2d file has been added
                let height = 150+64+(8+64)*(num-1)+100
                make.height.equalTo(height)
            } else { make.height.equalTo(150)}
        }
    }
        
    private func setupCancelButtonUI () {
        view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-52)
        }
    }
        
    //MARK: - Action Methods
        
    @objc private func cancelSubmission() {
        self.showConfirmView(title: "Отменить отправку?", text: "Отмените отправку, если хотите прикрепить другие файлы. После этого не забудьте повторно сдать задание", confirmButtonText: "Отменить отправку", declineButtonText: "Не отменять", confirmedAction: {[weak self] in
            Task {
                do {
                    try await self?.viewModel.cancelSubmission()
                    self?.getLessonDetails?()
                    self?.showNotification(message: "Отправка отменена", isSucceed: true)
                } catch {
                    print(error)
                    self?.showNotification(message: "Произошла ошибка", isSucceed: false)
                }
            }
        })
    }
    
}
