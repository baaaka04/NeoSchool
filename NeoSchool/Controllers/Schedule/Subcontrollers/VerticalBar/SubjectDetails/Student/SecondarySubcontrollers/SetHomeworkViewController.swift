import UIKit
import SnapKit
import PhotosUI

class SetHomeworkViewController: DetailTitledViewController, SubjectDetailsViewModelActionable, PHPickerViewControllerDelegate, UIDocumentPickerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, Notifiable {

    private let vm: TeacherDetailsViewModel

    var subtitleText: String? {
        didSet { subtitleLabel.text = subtitleText }
    }

    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 16))
    private let topicTextField = NeobisTextField()

    private let homeworkTaskTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.placeholder = "Задание"
        textView.placeholderInsets = UIEdgeInsets(top: 12, left: 16, bottom: Constants.textViewHeight-34, right: 16)
        textView.counterInsets = UIEdgeInsets(top: Constants.textViewHeight-34, left: 16, bottom: 12, right: 16)
        textView.limit = 100
        return textView
    }()

    private lazy var dateTextField: NeobisTextField = {
        let textField = NeobisTextField()
        textField.placeholder = "Срок сдачи"
        textField.addTarget(self, action: #selector(toggleCalendar), for: .touchDown)
        textField.rightView = calendarImageViewContainer
        textField.rightViewMode = .always
        return textField
    }()

    private lazy var calendarImageView : UIImageView = {
        let image = UIImage(named: "CalendarIcon")?.withTintColor(.neobisLightGray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var calendarImageViewContainer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: calendarImageView.frame.width+12, height: calendarImageView.frame.height))
        view.addSubview(calendarImageView)
        return view
    }()

    private lazy var addFilesButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .addFiles)
        button.delegate = self
        button.vc = self
        return button
    }()

    private lazy var saveButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Сохранить", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(setHomework), for: .touchUpInside)
        return button
    }()

    private let calendarView = CalendarView(frame: .zero)
    private let attachedFilesVC: FilesCollectionViewController

    init(vm: TeacherDetailsViewModel) {
        self.vm = vm
        self.attachedFilesVC = FilesCollectionViewController(attachedFiles: vm.attachedFiles)
        super.init(nibName: nil, bundle: nil)
        vm.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCollectionView()
    }

    private func setupCollectionView() {
        attachedFilesVC.onPressRemove = { [weak self] (_ file: AttachedFile) in
            self?.vm.remove(file: file)
        }
    }

    private func setupUI() {
        vm.attachedFiles = []
        topicTextField.text = ""
        homeworkTaskTextView.text = ""
        dateTextField.text = ""
        topicTextField.placeholder = "Тема урока"

        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }

        scrollView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalToSuperview()
        }
        scrollView.addSubview(topicTextField)
        topicTextField.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.height.equalTo(52)
        }
        scrollView.addSubview(homeworkTaskTextView)
        homeworkTaskTextView.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(topicTextField.snp.bottom).offset(16)
            make.height.equalTo(Constants.textViewHeight)
        }
        scrollView.addSubview(dateTextField)
        dateTextField.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(homeworkTaskTextView.snp.bottom).offset(16)
            make.height.equalTo(52)
        }
        scrollView.addSubview(addFilesButton)
        addFilesButton.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(dateTextField.snp.bottom).offset(16)
            make.height.equalTo(52)
        }
        addChild(attachedFilesVC)
        attachedFilesVC.didMove(toParent: self)
        scrollView.addSubview(attachedFilesVC.view)
        attachedFilesVC.collectionView.isScrollEnabled = false
        attachedFilesVC.view.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(addFilesButton.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(52)
            make.height.equalTo(52)
        }

        //MARK: Date Picker
        calendarView.delegate = dateTextField
        calendarView.toggleCalendarView = toggleCalendar
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { $0.centerX.centerY.equalToSuperview() }
    }

    private struct Constants {
        static let textViewHeight: CGFloat = 158
    }

    func updateCollectionView() {
        if vm.attachedFiles.count > 0 {
            self.saveButton.isEnabled = true
            updateFilesColletionHeight(numberOfElements: vm.attachedFiles.count)
        } else {
            self.saveButton.isEnabled = false
        }
        attachedFilesVC.update(attachedFiles: vm.attachedFiles)
    }

    private func updateFilesColletionHeight(numberOfElements count: Int) {
        attachedFilesVC.view.snp.updateConstraints { make in
// 64 - cell height; 8 - cells gap; 200 - additional height to activate scroll after the 2d file has been added
            let newHeight = 64+(8+64)*(count-1)+200
            make.height.equalTo(newHeight)
        }
    }

    @objc private func toggleCalendar() {
        if calendarView.isHidden {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateTextField.text = dateFormatter.string(from: Date())
        }
        calendarView.datePicker.date = Date()
        calendarView.isHidden.toggle()
        dateTextField.resignFirstResponder()
    }

    @objc private func setHomework() {
        Task {
            do {
                guard let topic = topicTextField.text,
                      let deadline = dateTextField.text else { throw MyError.cannotEncodeData }
                try await vm.setHomework(
                    topic: topic,
                    text: homeworkTaskTextView.text,
                    deadline: deadline) { [weak self] done in
                        DispatchQueue.main.async {
                            if done {
                                self?.showNotification(message: "Задание успешно отправлено", isSucceed: true)
                            } else {
                                self?.showNotification(message: "Неверный логин или пароль", isSucceed: false)
                            }
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
            } catch { print(error) }
        }
    }

    //MARK: - File picker functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            vm.add(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage else { return }
                    DispatchQueue.main.async {
                        self?.vm.add(image: image)
                    }
                }
            }
        }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        for url in urls {
            if let fileData = try? Data(contentsOf: url) {

                if let image = UIImage(data: fileData) {
                    vm.add(image: image)
                } else { print("Failed to create UIImage from file data: \(url)") }

            } else { print("Failed to load file data: \(url)") }
        }
    }
}
