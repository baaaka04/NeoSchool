import SnapKit
import UIKit

final class ProfileViewController: SchoolNavViewController {
    private let authService: AuthServiceProtocol
    private var infoView: ProfileInfoView?
    private let scrollview = UIScrollView()

    init(authService: AuthServiceProtocol, navbarTitle: String, navbarColor: UIColor?) {
        self.authService = authService
        super.init(navbarTitle: navbarTitle, navbarColor: navbarColor)
    }
    
    @available(*, unavailable)
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
            make.top.equalToSuperview().offset(184 - 10) // 10 = view's shadow radius
            make.width.equalToSuperview().offset(-32 + 20) // 20 = view's shadow radius (both sides)
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
                let profileInfo: ProfileInfo = try await authService.getProfileData()
                await MainActor.run {
                    self.infoView = ProfileInfoView(profileInfo: profileInfo)
                    self.setupUI()
                }
            } catch { print(error) }
        }
    }
}
