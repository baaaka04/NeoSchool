import UIKit
import SnapKit

class StudentHomeworkPanelViewController: HomeworkPanelViewController {

    var attachedFilesNumber: Int? {
        didSet {
            attachedFiles.text = "Прикрепленные материалы: \(attachedFilesNumber ?? 0)"
        }
    }
    
    private let attachedFiles: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 18)
        label.textColor = .neobisPurple
        label.text = "Прикрепленные материалы: 0"
        label.textAlignment = .left
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(attachedFiles)
        
        setupUI()
    }
    
    private func setupUI() {
        homeworkbodyLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        attachedFiles.snp.makeConstraints { make in
            make.top.equalTo(homeworkbodyLabel.snp.bottom).offset(8)
            make.bottom.left.right.equalToSuperview().inset(16)
        }
    }
    

}
