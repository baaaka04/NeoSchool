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
                
        configureWeekBar()
    }
    
    private func configureWeekBar () {
        let weekBar = WorkdayScheduleViewController()
        addChild(weekBar)
        weekBar.view.frame = view.frame
        
        view.addSubview(weekBar.view)
        weekBar.view.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width-32)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(168)
        }
        weekBar.didMove(toParent: self)


        let dayScheduleList = DaySubjectsViewController()
        addChild(dayScheduleList)
        dayScheduleList.view.frame = view.frame
        
        view.addSubview(dayScheduleList.view)
        dayScheduleList.view.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width-32)
            let lessonsAmount = dayLessonsMockData.count
            make.height.equalTo(32 + lessonsAmount * (75+24) - 24)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(weekBar.view.snp.bottom).offset(16)
        }
        dayScheduleList.didMove(toParent: self)
        dayScheduleList.view.layer.shadowColor = UIColor.neobisShadow.cgColor
        dayScheduleList.view.layer.shadowOpacity = 0.1
        dayScheduleList.view.layer.shadowOffset = .zero
        dayScheduleList.view.layer.shadowRadius = 10
        
    }


}
