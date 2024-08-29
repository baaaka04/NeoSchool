import UIKit
import SnapKit

class NotepadView: UIView {
    
    private let notepadImageView = UIImageView(image: UIImage(named: "Notepad"))

    var title: String? {
        didSet { titleLabel.text = title }
    }
    private let titleLabel: GrayUILabel = {
        let label = GrayUILabel(font: AppFont.font(type: .Medium, size: 22))
        label.textAlignment = .center
        return label
    }()
    
    var subtitle: String? {
        didSet { titleLabel.text = subtitle }
    }
    private let subtitleLabel: GrayUILabel = {
        let label = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    init(title: String? = nil, subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(notepadImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        notepadImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(160)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(notepadImageView.snp.bottom).offset(20)
            make.width.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.centerX.bottom.equalToSuperview()
        }
    }
    
}
