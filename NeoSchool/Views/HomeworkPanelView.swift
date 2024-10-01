import UIKit
import SnapKit

class HomeworkPanelView: UIView {

    enum PresentationMode {
        case student, teacherFull, teacherShort
    }

    private let presentaionMode: PresentationMode

    var homeworkText: String? {
        didSet {
            guard let homeworkText else { return }
            homeworkbodyLabel.text = homeworkText
        }
    }
        
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Домашнее задание:"
        title.font = AppFont.font(type: .Medium, size: 20)
        title.textColor = UIColor.neobisBlue
        return title
    }()
    
    private let homeworkbodyLabel: GrayUILabel = {
        let homeworkbodyLabel = GrayUILabel()
        homeworkbodyLabel.font = AppFont.font(type: .Regular, size: 18)
        homeworkbodyLabel.numberOfLines = 2
        homeworkbodyLabel.lineBreakMode = .byWordWrapping
        homeworkbodyLabel.textAlignment = .left
        homeworkbodyLabel.text = "Не задано"
        return homeworkbodyLabel
    }()

    var deadlineText: String? {
        didSet {
            deadlineLabel.text = deadlineText
        }
    }

    private let deadlineLabel = GrayUILabel(font: AppFont.font(type: .Italic, size: 18))

    var attachedFilesNumber: Int? {
        didSet {
            attachedFilesLabel.setTitle("Прикрепленные материалы: \(attachedFilesNumber ?? 0)", for: .normal)
        }
    }

    let attachedFilesLabel: UIButton = {
        let button = UIButton()
        button.setTitle("Прикрепленные материалы: 0", for: .normal)
        button.titleLabel?.font = AppFont.font(type: .Medium, size: 18)
        button.setTitleColor(.neobisPurple, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()

    private lazy var editTipLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Italic, size: 14)
        label.textColor = .neobisLightGray
//        if self.userRole == .teacher {
            label.text = "Нажмите на блок, чтобы изменить задание"
//        }
        label.numberOfLines = 0
        return label
    }()

    private let editImageView = UIImageView(image: UIImage(named: "regularedit"))

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, homeworkbodyLabel, deadlineLabel, editTipLabel, attachedFilesLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()


    init(presentaionMode: PresentationMode) {
        self.presentaionMode = presentaionMode
        super.init(frame: .zero)

        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupUI() {
        layer.borderWidth = 1.0
        layer.borderColor = CGColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        layer.cornerRadius = 16.0

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        addSubview(editImageView)
        editImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }

        switch presentaionMode {
        case .student:
            deadlineLabel.isHidden = true
            editTipLabel.isHidden = true
            editImageView.isHidden = true
        case .teacherFull:
            break
        case .teacherShort:
            editTipLabel.isHidden = true
            editImageView.isHidden = true
        }

    }
}
