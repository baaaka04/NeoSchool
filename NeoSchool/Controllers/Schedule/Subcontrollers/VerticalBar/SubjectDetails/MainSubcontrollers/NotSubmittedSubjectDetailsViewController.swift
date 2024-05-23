import UIKit
import SnapKit
import PhotosUI

class NotSubmittedSubjectDetailsViewController: SubjectDetailsViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextViewDelegate {
    
    //MARK: - Properties
    
    private let attachedFilesVC: FilesCollectionViewController
    
    lazy var uploadButton: UIButton = {
        let uploadButton = UIButton()
        uploadButton.setTitle("Отправить задание", for: .normal)
        uploadButton.backgroundColor = .neobisLightPurple
        uploadButton.layer.cornerRadius = 16
        uploadButton.titleLabel?.font = AppFont.font(type: .Regular, size: 20)
        uploadButton.isEnabled = false
        uploadButton.addTarget(self, action: #selector(openCommentView), for: .touchUpInside)
        return uploadButton
    }()
    
    lazy var addFilesButton: UIButton = {
        let addFilesButton = UIButton()
        addFilesButton.backgroundColor = .white
        addFilesButton.layer.cornerRadius = 16
        addFilesButton.layer.borderWidth = 1.0
        addFilesButton.layer.borderColor = UIColor.neobisPurple.cgColor
        return addFilesButton
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
                
        let plusIcon = UIImage(systemName: "plus.circle")?.withTintColor(.neobisDarkPurple, renderingMode: .alwaysOriginal)
        addFilesButton.setImage(plusIcon, for: .normal)
        addFilesButton.setTitle(" Прикрепить файлы", for: .normal)
        addFilesButton.setTitleColor(.neobisDarkPurple, for: .normal)
        addFilesButton.titleLabel?.font = AppFont.font(type: .Regular, size: 20)
        
        let openMediaAction = UIAction(title: "Медиатека") { [weak self] _ in
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 10
            configuration.selection = .ordered
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self?.present(picker, animated: true)
        }
        let takePhotoAction = UIAction(title: "Снять фото или видео") { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self?.present(picker, animated: true)
        }
        let selectFilesAction = UIAction(title: "Выбор файлов") { [weak self] _ in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = true
            self?.present(documentPicker, animated: true, completion: nil)
        }
        
        let menu = UIMenu(options: .displayInline, children: [selectFilesAction, takePhotoAction, openMediaAction])
        addFilesButton.menu = menu
        addFilesButton.showsMenuAsPrimaryAction = true
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
        let commentVC = CommentModalViewController()
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
            self.uploadButton.backgroundColor = .neobisPurple
            updateFilesColletionHeight(numberOfElements: viewModel.attachedFiles.count)
        } else {
            self.uploadButton.isEnabled = false
            self.uploadButton.backgroundColor = .neobisLightPurple
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
