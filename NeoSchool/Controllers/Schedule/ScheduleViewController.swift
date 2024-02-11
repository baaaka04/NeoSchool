import UIKit
import SnapKit


final class ScheduleViewController: SchoolNavViewController {
    
    override init(navbarTitle: String, navbarColor: UIColor?) {
        super.init(navbarTitle: navbarTitle, navbarColor: navbarColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
                
        configureDayScheduleBar()
    }
    
    private func configureDayScheduleBar () {
        let child = WorkdayScheduleViewController()
        addChild(child)
        child.view.frame = view.frame
        
        view.addSubview(child.view)
        child.view.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width-32)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(168)
        }
        child.didMove(toParent: self)
    }


}
