import UIKit
import SnapKit

final class ProfileViewController: SchoolNavViewController {
    
    private let authAPI = AuthService()
    private let scrollview = UIScrollView()
    private let isTeacher: Bool
    
    private var infoView: ProfileInfoView?
    
    init(navbarTitle: String, navbarColor: UIColor?, isTeacher: Bool) {
        self.isTeacher = isTeacher
        super.init(navbarTitle: navbarTitle, navbarColor: navbarColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfileData()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollview)
        scrollview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(184-10) // 10 = view's shadow radius
            make.width.equalToSuperview().offset(-32+20) // 20 = view's shadow radius (both sides)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.tabBarController?.tabBar.frame.size.height ?? 0)
        }
        
        if let infoView {
            scrollview.addSubview(infoView)
            
            infoView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().offset(-20) // 20 = view's shadow radius (both sides)
                make.top.equalToSuperview().offset(10) // 10 = view's shadow radius
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func getProfileData() {
        Task {
            do {
                let profileInfo: ProfileInfo = try await authAPI.getProfileData()
                DispatchQueue.main.async {
                    self.infoView = ProfileInfoView(profileInfo: profileInfo)
                    self.setupUI()
                }
            } catch { print(error) }
        }
    }
}
