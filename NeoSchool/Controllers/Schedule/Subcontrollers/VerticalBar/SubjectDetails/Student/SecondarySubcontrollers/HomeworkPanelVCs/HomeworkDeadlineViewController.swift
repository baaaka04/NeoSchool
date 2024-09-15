import UIKit
import SnapKit

class HomeworkDeadlineViewController: HomeworkPanelViewController {

    var deadlineText: String? {
        didSet {
            deadlineLabel.text = deadlineText
        }
    }

    let deadlineLabel = GrayUILabel(font: AppFont.font(type: .Italic, size: 18))

    override func updateUI() {
        homeworkbodyLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        if homeworkText != nil {

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
        }
    }

}
