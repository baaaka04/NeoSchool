import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupCustomBackButton()
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
