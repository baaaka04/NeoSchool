import UIKit
import SnapKit

class ScheduleViewController: UIViewController {
    
    let navbarTitle: String
    
    init(navbarTitle: String) {
        self.navbarTitle = navbarTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavBar()
        configureDaySchedule()
    }
    
    private func configureNavBar () {
        
        let ellipseView = EllipseView(color: UIColor(named: "ButtonColor"))
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
    
    private func configureDaySchedule () {
        let child = WorkdayScheduleViewController()
        addChild(child)
        child.view.frame = view.frame
        
        view.addSubview(child.view)
        child.view.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width-32)
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(232)
            make.height.equalTo(400)
        }
        child.didMove(toParent: self)
    }


}
