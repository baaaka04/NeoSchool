import UIKit
import SnapKit

class HomeworkPanelViewController: UIViewController {
    
    var homeworkText: String? {
        didSet {
            homeworkbodyLabel.text = homeworkText ?? "Не задано"
        }
    }
    
    var attachedFilesNumber: Int? {
        didSet {
            attachedFiles.text = "Прикрепленные материалы: \(attachedFilesNumber ?? 0)"
        }
    }
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Домашнее задание:"
        title.font = AppFont.font(type: .Medium, size: 20)
        title.textColor = UIColor.neobisBlue
        return title
    }()
    
    lazy var homeworkbodyLabel: GrayUILabel = {
        let homeworkbodyLabel = GrayUILabel()
        homeworkbodyLabel.font = AppFont.font(type: .Regular, size: 18)
        homeworkbodyLabel.numberOfLines = 2
        homeworkbodyLabel.lineBreakMode = .byWordWrapping
        homeworkbodyLabel.textAlignment = .left
        return homeworkbodyLabel
    }()
    
    lazy var attachedFiles: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 18)
        label.textColor = .neobisPurple
        label.text = "Прикрепленные материалы: -"
        label.textAlignment = .left
        return label
    }()
    
    lazy var editHomeworkLabel: UILabel = {
        let label = UILabel()
        label.text = "Нажмите на блок, чтобы изменить задание"
        label.font = AppFont.font(type: .Italic, size: 14)
        label.textColor = UIColor.neobisLightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.borderWidth = 1.0
        view.layer.borderColor = CGColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        view.layer.cornerRadius = 16.0
        
        view.addSubview(titleLabel)
        view.addSubview(homeworkbodyLabel)
        view.addSubview(attachedFiles)
        
        setupConstraints()
//MARK: Label and button appears only for a teacher
//        view.addSubview(editHomeworkLabel)
//        editHomeworkLabel.snp.makeConstraints { make in
//            make.height.equalTo(18)
//            make.left.equalToSuperview().offset(16)
//            make.top.equalTo(homeworkbodyLabel.snp.bottom).offset(8)
//        }
        
//        setupEditButtonUI()
        
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.left.equalToSuperview().offset(16)
        }
        homeworkbodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
        }
        attachedFiles.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(16)
        }
    }
    
    private func setupEditButtonUI() {
        let editIcon = UIImage(named: "regularedit")
        let editButton = UIButton(type: .custom)
        editButton.setImage(editIcon, for: .normal)
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    

}