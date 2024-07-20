import UIKit
import SnapKit


final class ScheduleViewController: SchoolNavViewController {
    
    private let userRole: UserRole
    
    init(navbarTitle: String, navbarColor: UIColor?, userRole: UserRole) {
        self.userRole = userRole
        super.init(navbarTitle: navbarTitle, navbarColor: navbarColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
                
        configureWeekBar()
    }
    
    private func configureWeekBar () {
        let weekBar = WorkdayScheduleViewController(userRole: self.userRole)
        addChild(weekBar)
        
        view.addSubview(weekBar.view)
        weekBar.view.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width-32)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(168)
        }
        weekBar.didMove(toParent: self)


        let dayScheduleList = DaySubjectsViewController(userRole: self.userRole)
        addChild(dayScheduleList)
        
        view.addSubview(dayScheduleList.view)
        dayScheduleList.view.snp.makeConstraints { make in
            make.top.equalTo(weekBar.view.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.tabBarController?.tabBar.frame.size.height ?? 0)
        }
        dayScheduleList.didMove(toParent: self)
        
        // Подписываем класс dayScheduleList на события в классе weekBar
        weekBar.delegate = dayScheduleList
    }


}
