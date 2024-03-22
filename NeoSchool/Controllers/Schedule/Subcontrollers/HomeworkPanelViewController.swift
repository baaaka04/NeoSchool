import UIKit
import SnapKit

class HomeworkPanelViewController: UIViewController {
    
    var homeworkText: String? {
        didSet {
            homeworkbodyLabel.text = homeworkText
        }
    }
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Домашнее задание:"
        title.font = UIFont(name: "Jost-Medium", size: 20)
        title.textColor = UIColor.neobisBlue
        return title
    }()
    
    lazy var homeworkbodyLabel: GrayUILabel = {
        let homeworkbodyLabel = GrayUILabel()
        homeworkbodyLabel.text = "Не задано"
        homeworkbodyLabel.font = UIFont(name: "Jost-Regular", size: 18)
        return homeworkbodyLabel
    }()
    
    lazy var editHomeworkLabel: UILabel = {
        let label = UILabel()
        label.text = "Нажмите на блок, чтобы изменить задание"
        label.font = UIFont(name: "Jost-Italic", size: 14)
        label.textColor = UIColor.neobisLightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.borderWidth = 1.0
        view.layer.borderColor = CGColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        view.layer.cornerRadius = 16.0
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.left.equalToSuperview().offset(16)
        }
        
        view.addSubview(homeworkbodyLabel)
        homeworkbodyLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
//MARK: Label and button appears only for a teacher
//        view.addSubview(editHomeworkLabel)
//        editHomeworkLabel.snp.makeConstraints { make in
//            make.height.equalTo(18)
//            make.left.equalToSuperview().offset(16)
//            make.top.equalTo(homeworkbodyLabel.snp.bottom).offset(8)
//        }
        
//        setupEditButtonUI()
        
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
