import UIKit
import SnapKit

class TeacherHomeworkPanelViewController: HomeworkPanelViewController {
    
    var deadlineText: String? {
        didSet {
            deadlineLabel.text = deadlineText
            updateUI()
        }
    }
    
    private let deadlineLabel = GrayUILabel(font: AppFont.font(type: .Italic, size: 18))

    private let editTipLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Italic, size: 14)
        label.textColor = .neobisLightGray
        label.text = "Нажмите на блок, чтобы изменить задание"
        label.numberOfLines = 0
        return label
    }()
    
    private let editImageView = UIImageView(image: UIImage(named: "regularedit"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(deadlineLabel)
        view.addSubview(editTipLabel)
        view.addSubview(editImageView)
        
        updateUI()
    }
    
    private func updateUI() {
        homeworkbodyLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        deadlineLabel.snp.remakeConstraints { make in
            make.top.equalTo(homeworkbodyLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        let lastConstraint = deadlineText != nil ? deadlineLabel.snp.bottom : homeworkbodyLabel.snp.bottom
        
        editTipLabel.snp.remakeConstraints { make in
            make.top.equalTo(lastConstraint).offset(8)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        editImageView.snp.remakeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
    }
    

}
