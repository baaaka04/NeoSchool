import UIKit
import SnapKit

class HomeworkPanelViewController: UIViewController {
    
    var homeworkText: String? {
        didSet {
            guard let homeworkText else { return }
            homeworkbodyLabel.text = homeworkText
        }
    }
        
    let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Домашнее задание:"
        title.font = AppFont.font(type: .Medium, size: 20)
        title.textColor = UIColor.neobisBlue
        return title
    }()
    
    let homeworkbodyLabel: GrayUILabel = {
        let homeworkbodyLabel = GrayUILabel()
        homeworkbodyLabel.font = AppFont.font(type: .Regular, size: 18)
        homeworkbodyLabel.numberOfLines = 2
        homeworkbodyLabel.lineBreakMode = .byWordWrapping
        homeworkbodyLabel.textAlignment = .left
        homeworkbodyLabel.text = "Не задано"
        return homeworkbodyLabel
    }()

    var attachedFilesNumber: Int? {
        didSet {
            attachedFilesLabel.text = "Прикрепленные материалы: \(attachedFilesNumber ?? 0)"
        }
    }

    let attachedFilesLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 18)
        label.textColor = .neobisPurple
        label.text = "Прикрепленные материалы: 0"
        label.textAlignment = .left
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.borderWidth = 1.0
        view.layer.borderColor = CGColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        view.layer.cornerRadius = 16.0

        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        view.addSubview(homeworkbodyLabel)
        homeworkbodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }

    func updateUI() {
        if let homeworkText {
            homeworkbodyLabel.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
                make.left.right.equalToSuperview().inset(16)
            }
            view.addSubview(attachedFilesLabel)
            attachedFilesLabel.snp.makeConstraints { make in
                make.top.equalTo(homeworkbodyLabel.snp.bottom).offset(8)
                make.left.right.bottom.equalToSuperview().inset(16)
            }
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
            make.right.equalToSuperview().inset(16)
        }
    }
    

}
