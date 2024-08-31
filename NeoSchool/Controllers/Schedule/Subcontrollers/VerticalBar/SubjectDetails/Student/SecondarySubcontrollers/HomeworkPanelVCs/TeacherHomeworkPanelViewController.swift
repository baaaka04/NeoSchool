import UIKit
import SnapKit

class TeacherHomeworkPanelViewController: HomeworkPanelViewController {
    
    var deadlineText: String? {
        didSet {
            deadlineLabel.text = deadlineText
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

        setupUI()
    }

    override func updateUI() {
        homeworkbodyLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        if homeworkText != nil {
            editTipLabel.snp.removeConstraints()
            editTipLabel.removeFromSuperview()

            view.addSubview(deadlineLabel)
            deadlineLabel.snp.remakeConstraints { make in
                make.top.equalTo(homeworkbodyLabel.snp.bottom).offset(8)
                make.left.right.equalToSuperview().inset(16)
            }
            view.addSubview(attachedFilesLabel)
            attachedFilesLabel.snp.remakeConstraints { make in
                make.top.equalTo(deadlineLabel.snp.bottom).offset(8)
                make.left.right.bottom.equalToSuperview().inset(16)
            }
        } else {
            deadlineLabel.snp.removeConstraints()
            deadlineLabel.removeFromSuperview()
            attachedFilesLabel.snp.removeConstraints()
            attachedFilesLabel.removeFromSuperview()
            
            view.addSubview(editTipLabel)
            editTipLabel.snp.makeConstraints { make in
                make.top.equalTo(homeworkbodyLabel.snp.bottom).offset(8)
                make.left.right.bottom.equalToSuperview().inset(16)
            }
        }
    }

    private func setupUI() {
        view.addSubview(editImageView)
        editImageView.snp.remakeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    

}
