import UIKit
import SnapKit
import PhotosUI

class SubjectDetailsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private let viewModel: SubjectDetailsViewModelRepresentable
    private let attachedFilesVC: AttachedFilesViewController
    
    private let homeworkPanel = HomeworkPanelViewController()
    
    lazy var scrollView = UIScrollView()
    
    lazy var titleLabel: GrayUILabel = {
        let titleLabel = GrayUILabel()
        titleLabel.font = UIFont(name: "Jost-SemiBold", size: 28)
        return titleLabel
    }()
    
    lazy var firstSubTitleLabel: GrayUILabel = {
        let firstSubTitleLabel = GrayUILabel()
        firstSubTitleLabel.font = UIFont(name: "Jost-Regular", size: 16)
        return firstSubTitleLabel
    }()
    
    lazy var secondSubTitleLabel: GrayUILabel = {
        let secondSubTitleLabel = GrayUILabel()
        secondSubTitleLabel.font = UIFont(name: "Jost-Regular", size: 16)
        return secondSubTitleLabel
    }()
    
    lazy var deadlineLabel: UILabel = {
        let deadlineLabel = UILabel(frame: .infinite)
        deadlineLabel.textAlignment = .right
        deadlineLabel.textColor = UIColor.neobisPurple
        deadlineLabel.font = UIFont(name: "Jost-Medium", size: 18)
        return deadlineLabel
    }()
    
    lazy var markLabel: GrayUILabel = {
        let markLabel = GrayUILabel()
        markLabel.font = UIFont(name: "Jost-Regular", size: 20)
        return markLabel
    }()
    
    lazy var uploadButton: UIButton = {
        let uploadButton = UIButton()
        uploadButton.setTitle("Отправить задание", for: .normal)
        uploadButton.backgroundColor = .neobisLightPurple
        uploadButton.layer.cornerRadius = 16
        uploadButton.titleLabel?.font = UIFont(name: "Jost-Regular", size: 20)
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
    
    lazy var commentView: CommentView = {
        let view = CommentView()
        view.uploadFiles = uploadFiles
        return view
    }()
    
    lazy var dimmingView: UIView = {
        let dimming = UIView()
        dimming.frame = view.bounds
        dimming.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        dimming.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideCommentView))
        dimming.addGestureRecognizer(tapGesture)
        return dimming
    }()
    
    
    init(viewModel: SubjectDetailsViewModelRepresentable) {
        self.viewModel = viewModel
        self.attachedFilesVC = AttachedFilesViewController(viewModel: self.viewModel)

        super.init(nibName: nil, bundle: nil)

        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(firstSubTitleLabel)
        scrollView.addSubview(secondSubTitleLabel)
        self.addChild(homeworkPanel)
        scrollView.addSubview(homeworkPanel.view)
        homeworkPanel.didMove(toParent: self)
        scrollView.addSubview(deadlineLabel)
        scrollView.addSubview(markLabel)
        
        self.addChild(attachedFilesVC)
        scrollView.addSubview(attachedFilesVC.view)
        attachedFilesVC.didMove(toParent: self)
        
        view.addSubview(uploadButton)
        view.addSubview(addFilesButton)
        
        view.addSubview(dimmingView)
        view.addSubview(commentView)
        
        setupConstraints()
        
        fillLabelsWithData()
        getLessonDetails()
        
        setupButtonsUI()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.add(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func getLessonDetails() {
        Task {
            try await viewModel.getLessonDetailData()
            fillLabelsWithData()
        }
    }
    
    private func updateFilesColletionHeight(count: Int) {
        attachedFilesVC.view.snp.updateConstraints { make in
// 64 - cell height; 8 - cells gap; 200 - additional height to activate scroll after the 2d file has been added
            let newHeight = 64+(8+64)*(count-1)+200
            make.height.equalTo(newHeight)
        }
    }
    
    private func setupButtonsUI () {
                
        let plusIcon = UIImage(systemName: "plus.circle")?.withTintColor(.neobisPurple, renderingMode: .alwaysOriginal)
        addFilesButton.setImage(plusIcon, for: .normal)
        addFilesButton.setTitle(" Прикрепить файлы", for: .normal)
        addFilesButton.setTitleColor(.neobisPurple, for: .normal)
        addFilesButton.titleLabel?.font = UIFont(name: "Jost-Regular", size: 20)
        
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
    
    @objc private func openCommentView() {
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.isHidden = false
            self.commentView.snp.updateConstraints( { $0.top.equalTo(self.view.snp.bottom).offset(-324) } )
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func hideCommentView() {
        UIView.animate(withDuration: 0.3) {
            self.commentView.commentInput.resignFirstResponder()
            self.dimmingView.isHidden = true
            self.commentView.snp.updateConstraints( { $0.top.equalTo(self.view.snp.bottom) } )
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func uploadFiles() {
        viewModel.studentComment = commentView.commentInput.text
        Task {
            do {
                try await viewModel.sendFiles()
            } catch { print(error) }
        }
    }
    
    private func fillLabelsWithData() {
        titleLabel.text = viewModel.subjectName
        firstSubTitleLabel.attributedText = viewModel.teacherName
        secondSubTitleLabel.attributedText = viewModel.homeworkTopic
        deadlineLabel.text = viewModel.homeworkDeadline
        markLabel.attributedText = viewModel.homeworkMark
        
        homeworkPanel.homeworkText = viewModel.homeworkText ?? "Не задано"
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalToSuperview()
        }
        firstSubTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        secondSubTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalTo(firstSubTitleLabel.snp.bottom)
        }
        homeworkPanel.view.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(112)
            make.centerX.equalToSuperview()
            make.top.equalTo(secondSubTitleLabel.snp.bottom).offset(16)
        }
        deadlineLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalTo(homeworkPanel.view.snp.bottom).offset(16)
        }
        markLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalTo(deadlineLabel.snp.bottom).offset(16)
        }
        attachedFilesVC.view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(64)
            make.top.equalTo(markLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
        uploadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-52)
        }
        addFilesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(52)
            make.bottom.equalTo(uploadButton.snp.top).offset(-12)
        }
        commentView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
            make.height.equalTo(324)
        }
    }
    
}

extension SubjectDetailsViewController: SubjectDetailsViewModelActionable {
    func reloadCollectionView() {
        if viewModel.attachedFiles.count > 0 {
            self.uploadButton.isEnabled = true
            self.uploadButton.backgroundColor = .neobisPurple
        } else {
            self.uploadButton.isEnabled = false
            self.uploadButton.backgroundColor = .neobisLightPurple
        }
        updateFilesColletionHeight(count: viewModel.attachedFiles.count)
        attachedFilesVC.reloadColletionView()
    }
}

extension SubjectDetailsViewController : PHPickerViewControllerDelegate {
    
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
}

extension SubjectDetailsViewController: UIDocumentPickerDelegate {
    
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

extension SubjectDetailsViewController: UITextViewDelegate {

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
                //TODO: add height to hide rounded bottom corners
                $0.top.equalTo(self.view.snp.bottom).offset( -(324+keyboardSize.height) )
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        commentView.snp.updateConstraints { $0.top.equalTo(self.view.snp.bottom).offset(-324) }
    }
}
