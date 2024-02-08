import UIKit

class PerformanceViewController: UIViewController {
    
    let navbarTitle: String
    
    init(navbarTitle: String) {
        self.navbarTitle = navbarTitle
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureNavBar()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    private func configureNavBar () {
        
        let ellipseView = EllipseView(color: UIColor(named: "NeobisBlue"))
        ellipseView.backgroundColor = .clear

        view.addSubview(ellipseView)
                
        let tabTitle = UILabel(frame: .zero)
        tabTitle.text = navbarTitle
        tabTitle.font = UIFont(name: "Jost-SemiBold", size: 32)
        tabTitle.textColor = .white
        
        view.addSubview(tabTitle)

        ellipseView.snp.makeConstraints { make in
            make.width.equalTo(644)
            make.height.equalTo(390)
            make.centerY.equalTo(72)
            make.centerX.equalToSuperview()
        }
        tabTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(112)
            make.left.equalToSuperview().inset(16)
        }
    }
}
