import UIKit
import SnapKit

class NavigationBarView: UIViewController {
    
    let color: UIColor?
    let navbarTitle: String
    
    init(color: UIColor?, navbarTitle: String) {
        self.color = color
        self.navbarTitle = navbarTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 343, height: 40))
        tabTitle.text = navbarTitle
        tabTitle.font = UIFont(name: "Jost-SemiBold", size: 32)
        
        let ellipseView = EllipseView(color: color)
        ellipseView.backgroundColor = .clear
        view.addSubview(ellipseView)
        view.addSubview(tabTitle)
        
        tabTitle.snp.makeConstraints { make in
            make.topMargin.equalTo(30)
            make.leadingMargin.equalTo(16)
        }
        
        ellipseView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(644)
            make.height.equalTo(390)
            make.centerY.equalTo(93)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
}
