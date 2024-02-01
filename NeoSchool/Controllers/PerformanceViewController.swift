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
        
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleView.text = "Привет, Айсулуу!"
        titleView.font = UIFont(name: "Jost-Medium", size: 20)
        
        navigationItem.titleView = titleView
        let navigationBarView = NavigationBarView(color: UIColor(named: "NeobisBlue"), navbarTitle: navbarTitle)
        view.addSubview(navigationBarView.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

}
