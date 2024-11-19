import SnapKit
import UIKit

class ContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.cornerRadius = 16
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.neobisShadow.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
