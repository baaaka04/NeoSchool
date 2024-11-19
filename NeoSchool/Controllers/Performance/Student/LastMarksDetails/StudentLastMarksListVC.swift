import SnapKit
import UIKit

class StudentLastMarksListVC: UIViewController, ItemsBarDelegate {
    private let performanceAPI: PerformanceAPIProtocol
    private var pageViewController: UIPageViewController!
    private var pages: [UIViewController] = []
    private let quater: Quater
    private let subjectId: Int

    weak var delegate: ItemsBarDelegate?

    init(performanceAPI: PerformanceAPIProtocol, quater: Quater, subjectId: Int) {
        self.performanceAPI = performanceAPI
        self.quater = quater
        self.subjectId = subjectId
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
    }

    private func setupPageViewController() {
        let homeworkListVC = HomeworkListViewController(
            performanceAPI: performanceAPI,
            quater: quater,
            subjectId: subjectId,
            hasDetails: true
        )
        let classworkListVC = ClassworkListViewController(
            performanceAPI: performanceAPI,
            quater: quater,
            subjectId: subjectId,
            hasDetails: false
        )
        pages = [homeworkListVC, classworkListVC]

        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func didSelectItem(itemId: Int) {
        let direction: UIPageViewController.NavigationDirection = itemId == 0 ? .forward : .reverse
        pageViewController.setViewControllers([pages[itemId]], direction: direction, animated: true, completion: nil)
    }
}

extension StudentLastMarksListVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1  else {
            return nil
        }
        return pages[index + 1]
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: visibleViewController) {
            delegate?.didSelectItem(itemId: index)
        }
    }
}
