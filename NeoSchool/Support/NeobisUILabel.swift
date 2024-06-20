import UIKit

class GrayUILabel: UILabel {
    
    init(font: UIFont) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = UIColor.neobisDarkGray
        self.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.neobisDarkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textColor = UIColor.neobisDarkGray
    }
}

class BigSemiBoldUILabel: GrayUILabel {
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        font = AppFont.font(type: .SemiBold, size: 32)
        textAlignment = .center
    }
}
