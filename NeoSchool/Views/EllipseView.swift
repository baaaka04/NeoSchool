import UIKit

class EllipseView: UIView {
    let color: UIColor?

    init(color: UIColor?) {
        self.color = color
        super.init(frame: .infinite)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let ellipsePath = UIBezierPath(ovalIn: rect)
        color?.setFill()
        ellipsePath.fill()
    }
}
