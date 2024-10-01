import UIKit
import PhotosUI

class NeobisUIButton: UIButton {

    weak var delegate: (PHPickerViewControllerDelegate & UIDocumentPickerDelegate & UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    weak var vc: UIViewController?

    enum ButtonType {
        case white, purple, red, addFiles
    }
    
    var type: ButtonType {
        didSet {
            self.setupUI()
        }
    }

    override var isEnabled: Bool {
        didSet {
            switch self.type {
            case .purple:
                self.backgroundColor = self.isEnabled ? .neobisPurple : .neobisLightPurple
            case .white, .red, .addFiles:
                break
            }
        }
    }

    init(type: ButtonType) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        switch self.type {
        case .white, .addFiles:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.neobisPurple.cgColor
            self.setTitleColor(.neobisPurple, for: .normal)
        case .purple:
            self.backgroundColor = .neobisPurple
            self.setTitleColor(.white, for: .normal)
        case .red:
            self.backgroundColor = .neobisRed
            self.setTitleColor(.white, for: .normal)
        }
        self.layer.cornerRadius = 16
        self.titleLabel?.font = AppFont.font(type: .Regular, size: 20)
    }

    private func setupActions() {
        switch self.type {

        case .addFiles:
            let plusIcon = UIImage(systemName: "plus.circle")?.withTintColor(.neobisDarkPurple, renderingMode: .alwaysOriginal)
            self.setImage(plusIcon, for: .normal)
            self.setTitle(" Прикрепить файлы", for: .normal)
            self.setTitleColor(.neobisDarkPurple, for: .normal)

            let openMediaAction = UIAction(title: "Медиатека") { [weak self] _ in
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 10
                configuration.selection = .ordered
                configuration.filter = .images

                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self?.delegate
                self?.vc?.present(picker, animated: true)
            }
            let takePhotoAction = UIAction(title: "Снять фото или видео") { [weak self] _ in
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self?.delegate
                self?.vc?.present(picker, animated: true)
            }
            let selectFilesAction = UIAction(title: "Выбор файлов") { [weak self] _ in
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
                documentPicker.delegate = self?.delegate
                documentPicker.allowsMultipleSelection = true
                self?.vc?.present(documentPicker, animated: true, completion: nil)
            }

            let menu = UIMenu(options: .displayInline, children: [openMediaAction, takePhotoAction, selectFilesAction])
            self.menu = menu
            self.showsMenuAsPrimaryAction = true

        case .white, .purple, .red:
            break

        }
    }

}
