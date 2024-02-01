import UIKit


class EllipseView: UIView {
    
    let color: UIColor?
    
    init(color: UIColor?) {
        self.color = color
        super.init(frame: .infinite)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ellipsePath = UIBezierPath(ovalIn: rect)
        color?.setFill()
        ellipsePath.fill()
    }
}
