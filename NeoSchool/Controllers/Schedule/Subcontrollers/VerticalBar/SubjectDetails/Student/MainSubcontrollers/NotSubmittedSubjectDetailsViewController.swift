import UIKit
import SnapKit
import PhotosUI

class NotSubmittedSubjectDetailsViewController: SubjectDetailsViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    private let attachedFilesVC: FilesCollectionViewController
    
    lazy var uploadButton: NeobisUIButton = {
        let uploadButton = NeobisUIButton(type: .purple)
        uploadButton.setTitle("Отправить задание", for: .normal)
        uploadButton.isEnabled = false
        uploadButton.addTarget(self, action: #selector(openCommentView), for: .touchUpInside)
        return uploadButton
    }()
    
    private lazy var addFilesButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .addFiles)
        button.delegate = self
        button.vc = self
        return button
    }()

    //MARK: - Initializers
    
    override init(viewModel: SubjectDetailsViewModelRepresentable) {
        self.attachedFilesVC = FilesCollectionViewController(attachedFiles: viewModel.attachedFiles)

        super.init(viewModel: viewModel)
        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsUI()
        setupStudentFilesUI()
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
    }
    
    private func setupStudentFilesUI() {
        self.addChild(attachedFilesVC)
        scrollView.addSubview(attachedFilesVC.view)
        attachedFilesVC.didMove(toParent: self)
        
        attachedFilesVC.onPressRemove = { [weak self] (_ file: AttachedFile) in
            self?.viewModel.remove(file: file)
        }
        updateAttachedFilesConstraints()
    }
    
    private func updateAttachedFilesConstraints() {
        attachedFilesVC.view.snp.updateConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.height.equalTo(64)
            make.top.equalTo(markLabel.snp.bottom).offset(Constants.gap)
            make.bottom.equalToSuperview()
        }
    }
        
    private func setupButtonsUI () {
        view.addSubview(uploadButton)
        view.addSubview(addFilesButton)
        
        uploadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-52)
        }
        addFilesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.height.equalTo(52)
            make.bottom.equalTo(uploadButton.snp.top).offset(-12)
        }
                
    }
        
    //MARK: - Action Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.add(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc private func openCommentView() {
        let commentVC = CommentModalViewController(userRole: .student)
        commentVC.delegate = self.viewModel as? CommentRepresentable
        commentVC.getLessonDetails = { [weak self] in
            self?.getLessonDetails?()
            self?.updateCollectionView()
        }
        commentVC.modalPresentationStyle = .overFullScreen
        self.present(commentVC, animated: false)
    }
            
}

//MARK: Update amount of files, colletionView height and uploadButton state after changing files array
extension NotSubmittedSubjectDetailsViewController: SubjectDetailsViewModelActionable {
    func updateCollectionView() {
        if viewModel.attachedFiles.count > 0 {
            self.uploadButton.isEnabled = true
            updateFilesColletionHeight(numberOfElements: viewModel.attachedFiles.count)
        } else {
            self.uploadButton.isEnabled = false
        }
        attachedFilesVC.update(attachedFiles: viewModel.attachedFiles)
    }
    
    private func updateFilesColletionHeight(numberOfElements count: Int) {
        attachedFilesVC.view.snp.updateConstraints { make in
// 64 - cell height; 8 - cells gap; 200 - additional height to activate scroll after the 2d file has been added
            let newHeight = 64+(8+64)*(count-1)+200
            make.height.equalTo(newHeight)
        }
    }
}

//MARK: - Image Pickers
extension NotSubmittedSubjectDetailsViewController : PHPickerViewControllerDelegate, UIDocumentPickerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage else { return }
                    DispatchQueue.main.async {
                        self?.viewModel.add(image: image)
                    }
                }
            }
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        for url in urls {
            if let fileData = try? Data(contentsOf: url) {
                
                if let image = UIImage(data: fileData) {
                    viewModel.add(image: image)
                } else { print("Failed to create UIImage from file data: \(url)") }
                
            } else { print("Failed to load file data: \(url)") }
        }
    }
}
