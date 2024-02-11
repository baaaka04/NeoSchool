import UIKit

final class PerformanceViewController: SchoolNavViewController {
    
    override init(navbarTitle: String, navbarColor: UIColor?) {
        super.init(navbarTitle: navbarTitle, navbarColor: navbarColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
