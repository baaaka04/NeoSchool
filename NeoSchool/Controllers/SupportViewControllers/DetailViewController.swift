import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    lazy var navBarTitle : UILabel = {
        let label = UILabel()
        label.text = self.title
        label.font = AppFont.font(type: .Medium, size: 20)
        label.textColor = .neobisDarkGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true

        setupCustomBackButton()
        
        self.navigationItem.titleView = navBarTitle
    }
    
    func setupCustomBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "regularchevron-left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        if let vcs = navigationController?.viewControllers, vcs.count == 1 {
            self.tabBarController?.tabBar.isHidden = false
            self.tabBarController?.tabBar.backgroundColor = .white
        }
    }
}
