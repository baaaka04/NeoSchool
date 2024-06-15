import UIKit

class NeobisUIButton: UIButton {
    
    enum ButtonType {
        case white, purple, red
    }
    
    private let type: ButtonType
    
    override var isEnabled: Bool {
        didSet {
            switch self.type {
            case .white:
                break
            case .purple:
                self.backgroundColor = self.isEnabled ? .neobisPurple : .neobisLightPurple
            case .red:
                break
            }
        }
    }

    init(type: ButtonType) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        switch self.type {
        case .white:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.neobisPurple.cgColor
            self.setTitleColor(.neobisPurple, for: .normal)
        case .purple:
            self.backgroundColor = .neobisPurple
            self.setTitleColor(.white, for: .normal)
        case .red:
            self.backgroundColor = .neobisRed
            self.setTitleColor(.white, for: .normal)
        }
        self.layer.cornerRadius = 16
        self.titleLabel?.font = AppFont.font(type: .Regular, size: 20)
    }
    
}
