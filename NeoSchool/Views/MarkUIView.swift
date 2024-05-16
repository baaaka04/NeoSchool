import UIKit
import SnapKit

class MarkUIView: UIView {
    
    var mark: Grade? {
        didSet {
            markLabel.text = (mark?.rawValue ?? "не получена") + " " + (mark?.word ?? "")
            markLabel.textColor = mark?.color
        }
    }

    private let headLabel: UILabel = {
        let label = UILabel()
        label.text = "Оценка за задание: "
        label.font = AppFont.font(type: .Regular, size: 20)
        label.textColor = .neobisDarkGray
        return label
    }()
    
    private let markLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 20)
        label.textColor = .neobisDarkGray
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(headLabel)
        addSubview(markLabel)
        
        headLabel.snp.makeConstraints { $0.leading.top.bottom.equalToSuperview() }
        markLabel.snp.makeConstraints { make in
            make.leading.equalTo(headLabel.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
        }
    }
    
}
